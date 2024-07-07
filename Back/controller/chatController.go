package controller

import (
	"Colibris/model"
	"Colibris/service"
	"Colibris/utils"
	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"log"
	"net/http"
)

type ChatController struct {
	Service *service.ChatService
}

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

func NewChatController(service *service.ChatService) *ChatController {
	return &ChatController{Service: service}
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

	firebaseClient, err := utils.NewFirebaseClient()
	if err != nil {
		log.Printf("error initializing Firebase client: %v\n", err)
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to initialize Firebase client"})
		return
	}

	for {
		_, msg, err := conn.ReadMessage()
		if err != nil {
			break
		}

		c.Service.BroadcastMessage(colocationID, msg, userID, senderName)

		title := "Nouveau message dans la colocation"
		body := string(msg)
		topic := "room_colocation_" + colocationID

		err = firebaseClient.SendNotification(title, body, senderName, colocationID, topic)
		if err != nil {
			log.Printf("error sending notification: %v\n", err)
		}
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
