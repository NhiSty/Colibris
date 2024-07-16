package route

import (
	"Colibris/controller"
	"Colibris/middleware"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func TaskRoutes(taskRoutes *gin.RouterGroup, db *gorm.DB) {
	routes := taskRoutes.Group("/tasks")
	taskService := service.NewTaskService(db)
	taskController := controller.NewTaskController(taskService)
	AuthMiddleware := middleware.AuthMiddleware
	{
		routes.GET("/search", AuthMiddleware("ROLE_ADMIN"), taskController.SearchTasks)
		routes.GET("", AuthMiddleware("ROLE_ADMIN"), taskController.GetAllTasks)
		routes.POST("", AuthMiddleware(), taskController.CreateTask)
		routes.GET("/:id", AuthMiddleware(), taskController.GetTaskById)
		routes.GET("/user/:userId", AuthMiddleware(), taskController.GetAllUserTasks)
		routes.GET("/colocation/:colocationId", AuthMiddleware(), taskController.GetAllCollocationTasks)
		routes.PUT("/:id", AuthMiddleware(), taskController.UpdateTask)
		routes.DELETE("/:id", AuthMiddleware(), taskController.DeleteTask)
	}
}
