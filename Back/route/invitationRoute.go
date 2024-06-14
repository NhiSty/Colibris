package route

import (
	"Colibris/controller"
	"Colibris/middleware"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func InvitationRoutes(invitationRoutes *gin.RouterGroup, db *gorm.DB) {
	routes := invitationRoutes.Group("/invitations")
	invService := service.NewInvitationService(db)
	invController := controller.NewInvitationController(invService)
	AuthMiddleware := middleware.AuthMiddleware
	{
		routes.POST("", AuthMiddleware(), invController.CreateInvitation)
		routes.PATCH("", AuthMiddleware(), invController.UpdateInvitation)
		routes.GET("/user/:id", AuthMiddleware(), invController.GetAllUserInvitation)

	}
}
