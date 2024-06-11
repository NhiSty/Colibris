package invitations

import (
	"Colibris/middlewares"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(invitationRoutes *gin.RouterGroup, db *gorm.DB) {
	routes := invitationRoutes.Group("/invitations")
	invRepo := NewInvitationRepository(db)
	invService := NewInvitationService(invRepo)
	invController := NewInvitationController(invService)
	AuthMiddleware := middlewares.AuthMiddleware
	{
		routes.POST("", AuthMiddleware(), invController.CreateInvitation)
		routes.PATCH("", AuthMiddleware(), invController.UpdateInvitation)
		routes.GET("/user/:id", AuthMiddleware(), invController.GetAllUserInvitation)

	}
}
