package tasks

import (
	"Colibris/middlewares"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(taskRoutes *gin.RouterGroup, db *gorm.DB) {
	routes := taskRoutes.Group("/tasks")
	taskRepo := NewTaskRepository(db)
	taskService := NewTaskService(taskRepo)
	taskController := NewTaskController(taskService)
	AuthMiddleware := middlewares.AuthMiddleware
	{
		routes.POST("", AuthMiddleware(), taskController.CreateTask)
		routes.GET("/:id", AuthMiddleware(), taskController.GetTaskById)
		routes.GET("/user/:userId", AuthMiddleware(), taskController.GetAllUserTasks)
		routes.PATCH("/:id", AuthMiddleware(), taskController.UpdateTask)
	}
}
