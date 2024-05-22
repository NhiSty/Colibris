package auth

import (
	"Colibris/middlewares"
	"Colibris/users"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(authRoutes *gin.RouterGroup, db *gorm.DB) {
	userRepo := users.NewUserRepository(db)
	authService := NewAuthService(userRepo)
	authController := NewAuthController(authService)
	AuthMiddleware := middlewares.AuthMiddleware
	routes := authRoutes.Group("/auth")
	{
		routes.POST("login", authController.Login)
		routes.GET("me", AuthMiddleware(), authController.Me)
		routes.POST("register", authController.Register)
	}
}
