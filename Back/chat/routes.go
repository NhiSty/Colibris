package chat

import (
	"Colibris/middlewares"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(chatRoutes *gin.RouterGroup, db *gorm.DB) {
	chatRepo := NewChatRepository(db)
	chatService := NewChatService(chatRepo)
	chatController := NewChatController(chatService)
	authMiddleware := middlewares.AuthMiddleware

	routes := chatRoutes.Group("chat")
	{
		routes.GET("/colocations/:colocation_id/messages", authMiddleware(), chatController.GetMessages)
		routes.GET("/colocations/:colocation_id/ws", authMiddleware(), chatController.HandleConnections)
	}
}
