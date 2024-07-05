package route

import (
	"Colibris/controller"
	"Colibris/middleware"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func VoteRoutes(voteRoutes *gin.RouterGroup, db *gorm.DB) {
	routes := voteRoutes.Group("/votes")
	voteService := service.NewVoteService(db)
	voteController := controller.NewVoteController(voteService)
	AuthMiddleware := middleware.AuthMiddleware
	{
		routes.POST("", AuthMiddleware(), voteController.AddVote)
		routes.GET("/tasks/:taskId", AuthMiddleware(), voteController.GetVotesByTaskId)
		routes.GET("/users/:userId", AuthMiddleware(), voteController.GetVotesByUserId)
		routes.PUT("/:voteId", AuthMiddleware(), voteController.UpdateVote)
	}
}
