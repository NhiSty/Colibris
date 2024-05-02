package auth

import (
	"github.com/gin-gonic/gin"
)

func AuthRoutes(authRoutes *gin.Engine) {
	routes := authRoutes.Group("/auth")
	authController := Controller{}
	{
		routes.POST("login", authController.Login)
		routes.POST("register", authController.Register)
	}
}
