package auth

import (
	"Colibris/users"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(authRoutes *gin.RouterGroup, db *gorm.DB) {
	userRepo := users.NewUserRepository(db)
	authService := NewAuthService(userRepo)
	authController := NewAuthController(authService)

	routes := authRoutes.Group("/auth")
	{
		routes.POST("login", authController.Login)
		routes.POST("register", authController.Register)
	}
}
