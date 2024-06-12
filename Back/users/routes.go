package users

import (
	// @TODO : a remettre quand les droits seront en place
	//"Colibris/middlewares"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(userRoutes *gin.RouterGroup, db *gorm.DB) {
	userRepo := NewUserRepository(db)
	userController := NewUserController(userRepo)
	routes := userRoutes.Group("/users")
	// @TODO : a remettre quand les droits seront en place
	//AuthMiddleware := middlewares.AuthMiddleware
	/*
		{
			routes.GET("", userController.GetAllUsers)
			routes.GET("/search", userController.SearchUsers)
			routes.GET("/:id", AuthMiddleware(), userController.GetUserById)
			routes.PATCH("/:id", AuthMiddleware(), userController.UpdateUser)
			routes.DELETE("/:id", userController.DeleteUserById)
		}

	*/

	{
		routes.GET("", userController.GetAllUsers)
		routes.GET("/search", userController.SearchUsers)
		routes.GET("/:id", userController.GetUserById)
		routes.PATCH("/:id", userController.UpdateUser)
		routes.DELETE("/:id", userController.DeleteUserById)
	}
}
