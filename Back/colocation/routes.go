package colocations

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(colocationRoutes *gin.RouterGroup, db *gorm.DB) {
	routes := colocationRoutes.Group("/colocations")
	colocRepo := NewColocationRepository(db)
	colocService := NewColocationService(colocRepo)
	colocationController := NewColocController(colocService)
	{
		routes.POST("", colocationController.CreateColocation)
		routes.GET("/:id", colocationController.GetColocationById)
		routes.GET("/user/:userId", colocationController.GetAllUserColocations)

	}
}
