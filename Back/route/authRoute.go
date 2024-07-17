package route

import (
	"Colibris/controller"
	"Colibris/middleware"
	"Colibris/service"
	"Colibris/utils"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func AuthRoutes(authRoutes *gin.RouterGroup, db *gorm.DB) {
	firebaseClient, _ := utils.NewFirebaseClient()
	authService := service.NewAuthService(db, firebaseClient)
	authController := controller.NewAuthController(authService)
	AuthMiddleware := middleware.AuthMiddleware
	routes := authRoutes.Group("/auth")
	{
		routes.POST("login", authController.Login)
		routes.GET("me", AuthMiddleware(), authController.Me)
		routes.POST("register", authController.Register)
		routes.POST("validate-token", authController.ValidateToken)
	}
}
