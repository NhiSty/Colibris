package route

import (
	"Colibris/controller"
	"Colibris/middleware"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func ChatRoutes(chatRoutes *gin.RouterGroup, db *gorm.DB) {

	chatService := service.NewChatService(db)
	colocMemberService := service.NewColocMemberService(db)
	chatController := controller.NewChatController(chatService, &colocMemberService)
	authMiddleware := middleware.AuthMiddleware

	routes := chatRoutes.Group("chat")
	{
		routes.GET("/colocations/:colocation_id/messages", authMiddleware(), chatController.GetMessages)
		routes.GET("/colocations/:colocation_id/ws", authMiddleware(), chatController.HandleConnections)
		routes.GET("/colocations/:colocation_id/admin/ws", chatController.HandleAdminConnections)
	}
}
