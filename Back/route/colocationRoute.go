package route

import (
	"Colibris/controller"
	"Colibris/middleware"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func ColocationRoutes(colocationRoutes *gin.RouterGroup, db *gorm.DB) {
	routes := colocationRoutes.Group("/colocations")
	colocService := service.NewColocationService(db)
	colocationController := controller.NewColocController(colocService)
	AuthMiddleware := middleware.AuthMiddleware
	{
		routes.POST("", AuthMiddleware(), colocationController.CreateColocation)
		routes.PATCH("/:id", AuthMiddleware(), colocationController.UpdateColocation)
		routes.GET("/:id", AuthMiddleware(), colocationController.GetColocationById)
		routes.GET("/user/:userId", AuthMiddleware(), colocationController.GetAllUserColocations)
		routes.DELETE("/:id", AuthMiddleware(), colocationController.DeleteColocation)

	}
}
