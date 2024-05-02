package users

import "github.com/gin-gonic/gin"

func UserRoutes(userRoutes *gin.Engine) {
	routes := userRoutes.Group("/users")
	userController := Controller{}
	{
		routes.GET("", userController.GetAllUsers)
		routes.GET("/:id", userController.GetUserById)
	}
}
