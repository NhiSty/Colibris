package route

import (
	"Colibris/controller"
	"Colibris/middleware"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func AuthRoutes(authRoutes *gin.RouterGroup, db *gorm.DB) {
	authService := service.NewAuthService(db)
	authController := controller.NewAuthController(authService)
	AuthMiddleware := middleware.AuthMiddleware
	routes := authRoutes.Group("/auth")
	{
		routes.POST("login", authController.Login)
		routes.GET("me", AuthMiddleware(), authController.Me)
		routes.POST("register", authController.Register)
	}
}
