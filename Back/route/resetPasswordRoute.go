package route

import (
	controllers "Colibris/controller"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func ResetPasswordRoutes(r *gin.RouterGroup, db *gorm.DB) {
	resetPasswordService := service.NewResetPasswordService(db)
	controller := controllers.NewResetPasswordController(resetPasswordService)
	routes := r.Group("/auth")
	{
		routes.POST("/forgot-password", controller.ForgotPassword)
		routes.GET("/ask-reset-password/:token", controller.AskResetPassword)
		routes.POST("/reset-password", controller.ResetPassword)
	}
}
