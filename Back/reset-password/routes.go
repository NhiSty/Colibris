package reset_password

import (
	"Colibris/users"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(r *gin.RouterGroup, db *gorm.DB) {
	resetPasswordRepo := NewResetPasswordRepository(db)
	userRepo := users.NewUserRepository(db)

	resetPasswordService := NewResetPasswordService(resetPasswordRepo, userRepo)
	controller := NewResetPasswordController(resetPasswordService)
	routes := r.Group("/auth")
	{
		routes.POST("/forgot-password", controller.ForgotPassword)
		routes.GET("/ask-reset-password/:token", controller.AskResetPassword)
		routes.POST("/reset-password", controller.ResetPassword)
	}
}
