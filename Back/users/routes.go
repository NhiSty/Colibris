package users

import (
	"Colibris/middlewares"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(userRoutes *gin.RouterGroup, db *gorm.DB) {
	userRepo := NewUserRepository(db)
	userController := NewUserController(userRepo)
	routes := userRoutes.Group("/users")
	AuthMiddleware := middlewares.AuthMiddleware

	{
		routes.GET("", userController.GetAllUsers)
		routes.GET("/:id", AuthMiddleware(), userController.GetUserById)
		routes.PATCH("/:id", AuthMiddleware(), userController.UpdateUser)
		routes.DELETE("/:id", userController.DeleteUserById)
	}
}
