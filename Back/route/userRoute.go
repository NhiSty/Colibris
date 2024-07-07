package route

import (
	controllers "Colibris/controller"
	"Colibris/middleware"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func UserRoutes(userRoutes *gin.RouterGroup, db *gorm.DB) {
	userService := service.NewUserService(db)
	userController := controllers.NewUserController(userService)
	routes := userRoutes.Group("/users")
	AuthMiddleware := middleware.AuthMiddleware

	{
		routes.GET("", AuthMiddleware("ROLE_ADMIN"), userController.GetAllUsers)
		routes.GET("/:id", AuthMiddleware(), userController.GetUserById)
		routes.PATCH("/:id", AuthMiddleware(), userController.UpdateUser)
		routes.DELETE("/:id", AuthMiddleware(), userController.DeleteUserById)
		routes.GET("/search", AuthMiddleware("ROLE_ADMIN"), userController.SearchUsers)
		routes.PATCH("/add-fcm-token", AuthMiddleware(), userController.AddFcmToken)
	}
}
