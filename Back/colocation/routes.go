package colocations

import (
	"Colibris/middlewares"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(colocationRoutes *gin.RouterGroup, db *gorm.DB) {
	routes := colocationRoutes.Group("/colocations")
	colocRepo := NewColocationRepository(db)
	colocService := NewColocationService(colocRepo)
	colocationController := NewColocController(colocService)
	AuthMiddleware := middlewares.AuthMiddleware
	{
		routes.POST("", AuthMiddleware(), colocationController.CreateColocation)
		routes.GET("/:id", AuthMiddleware(), colocationController.GetColocationById)
		routes.GET("/user/:userId", AuthMiddleware(), colocationController.GetAllUserColocations)

	}
}
