package controller

import (
	"Colibris/model"
	"Colibris/service"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"github.com/gorilla/websocket"
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

	isMember, err := c.ColocMemberService.IsMemberOfColocation(userID, uint(colocationIdToInt))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if !isMember {
		ctx.JSON(http.StatusForbidden, gin.H{"error": "You are not a member of this colocation"})
		return
	}

	conn, err := upgrader.Upgrade(ctx.Writer, ctx.Request, nil)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer func(conn *websocket.Conn) {
		err := conn.Close()
		if err != nil {
			return
		}
	}(conn)

	client := &model.Client{Conn: conn, ColocationID: colocationID}
	c.Service.RegisterClient(client)

	for {
		_, msg, err := conn.ReadMessage()
		if err != nil {
			break
		}
		c.Service.BroadcastMessage(colocationID, msg, userID, senderName)
	}
}

func (c *ChatController) GetMessages(ctx *gin.Context) {
	colocationID := ctx.Param("colocation_id")
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
			updatedMessage := fmt.Sprintf("⚠️ Message d'un administrateur: %s", string(msg))

			if err != nil {
				break
			}
			c.Service.BroadcastMessage(colocationID, []byte(updatedMessage), int(userID), senderName)
		}
	} else {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token claims"})
		ctx.Abort()
	}
}
