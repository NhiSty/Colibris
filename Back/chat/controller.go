package chat

import (
	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"net/http"
)

type ChatController struct {
	Service *ChatService
}

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

func NewChatController(service *ChatService) *ChatController {
	return &ChatController{Service: service}
}

func (c *ChatController) HandleConnections(ctx *gin.Context) {
	colocationID := ctx.Param("colocation_id")
	userIDFromToken, exists := ctx.Get("userID")
	if !exists {
		ctx.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}
	userID, ok := userIDFromToken.(int)
	if !ok {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID format"})
		return
	}
	conn, err := upgrader.Upgrade(ctx.Writer, ctx.Request, nil)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer conn.Close()

	client := &Client{Conn: conn, ColocationID: colocationID}
	c.Service.RegisterClient(client)

	for {
		_, msg, err := conn.ReadMessage()
		if err != nil {
			break
		}
		c.Service.BroadcastMessage(colocationID, msg, userID)
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
