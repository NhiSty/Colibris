package controller

import (
	"Colibris/model"
	"Colibris/service"
	"Colibris/utils"
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"github.com/gorilla/websocket"
	"log"
	"net/http"
	"strconv"
)

type ChatController struct {
	Service            *service.ChatService
	ColocMemberService *service.ColocMemberService
}

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

func NewChatController(service *service.ChatService, colocMemberService *service.ColocMemberService) *ChatController {
	return &ChatController{Service: service, ColocMemberService: colocMemberService}
}

func (c *ChatController) HandleConnections(ctx *gin.Context) {
	colocationID := ctx.Param("colocation_id")
	userIDFromToken, exists := ctx.Get("userID")

	if !exists {
		ctx.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}
	userID := int(userIDFromToken.(uint))

	firstName, _ := ctx.Get("firstName")
	lastName, _ := ctx.Get("lastName")
	senderName := firstName.(string) + " " + lastName.(string)

	colocationIdToInt, err := strconv.ParseUint(colocationID, 10, 32)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid colocation ID"})
		return
	}

	isMember, err := c.ColocMemberService.IsMemberOfColocation(userID, uint(colocationIdToInt))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if !isMember {
		fmt.Println("You  are not a member of this colocace")
		ctx.JSON(http.StatusForbidden, gin.H{"error": "You are not a member of this colocation"})
		return
	}

	firebaseClient, err := utils.NewFirebaseClient()
	if err != nil {
		log.Printf("error initializing Firebase client: %v\n", err)
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to initialize Firebase client"})
		return
	}

	conn, err := upgrader.Upgrade(ctx.Writer, ctx.Request, nil)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer conn.Close()

	client := &model.Client{Conn: conn, ColocationID: colocationID}
	c.Service.RegisterClient(client)

	for {
		_, msg, err := conn.ReadMessage()
		if err != nil {
			break
		}

		c.Service.BroadcastMessage(colocationID, msg, userID, senderName)

		title := "Nouveau message dans la colocation"
		body := string(msg)
		topic := "colocation_room_" + colocationID

		err = firebaseClient.SendNotification(title, body, senderName, colocationID, topic)
		if err != nil {
			log.Printf("error sending notification: %v\n", err)
		}
	}
}

func (c *ChatController) GetMessages(ctx *gin.Context) {
	colocationID := ctx.Param("colocation_id")
	userIDFromToken, exists := ctx.Get("userID")

	if !exists {
		fmt.Println(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}
	userID := int(userIDFromToken.(uint))
	userRole, _ := ctx.Get("role")

	colocationIdToInt, err := strconv.ParseUint(colocationID, 10, 32)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid colocation ID"})
		return
	}

	// Check if the user is a member of the colocation
	isMember, err := c.ColocMemberService.IsMemberOfColocation(userID, uint(colocationIdToInt))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// If the user is not a member and not an admin, deny access
	if !isMember && userRole != "ROLE_ADMIN" {
		ctx.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	// Fetch messages if the user is authorized
	messages, err := c.Service.GetMessages(colocationID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, messages)
}

func (c *ChatController) HandleAdminConnections(ctx *gin.Context) {
	colocationID := ctx.Param("colocation_id")
	tokenString := ctx.Query("token")
	if tokenString == "" {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "Token is required"})
		return
	}

	token, err := service.VerifyJWT(tokenString)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired JWT", "details": err.Error()})
		return
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		userID := uint(claims["user_id"].(float64))
		userRole := claims["role"].(string)
		if userRole != "ROLE_ADMIN" {
			ctx.JSON(http.StatusForbidden, gin.H{"error": "You do not have permission to access this route"})
			return
		}

		firstName := claims["first_name"].(string)
		lastName := claims["last_name"].(string)
		senderName := firstName + " " + lastName

		conn, err := upgrader.Upgrade(ctx.Writer, ctx.Request, nil)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		defer conn.Close()

		client := &model.Client{Conn: conn, ColocationID: colocationID}
		c.Service.RegisterClient(client)

		for {
			_, msg, err := conn.ReadMessage()
			if err != nil {
				break
			}

			// Log the raw message
			fmt.Println("Received message:", string(msg))

			var message map[string]interface{}
			if err := json.Unmarshal(msg, &message); err != nil {
				fmt.Println("Error unmarshalling message:", err)
				continue
			}

			if messageType, ok := message["type"].(string); ok {
				if messageType == "delete" {
					if messageID, ok := message["messageID"].(float64); ok {
						err := c.Service.DeleteMessage(colocationID, int(messageID))
						if err == nil {
							c.Service.BroadcastDeleteMessage(colocationID, int(messageID))
						} else {
							fmt.Println("Error deleting message:", err)
						}
					}
				} else {
					content, ok := message["content"].(string)
					if !ok {
						fmt.Println("Invalid message content")
						continue
					}
					updatedMessage := fmt.Sprintf("⚠️ Message d'un administrateur: %s", content)
					c.Service.BroadcastMessage(colocationID, []byte(updatedMessage), int(userID), senderName)
				}
			}
		}
	} else {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token claims"})
		ctx.Abort()
	}
}
