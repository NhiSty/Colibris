package route

import (
	"Colibris/controller"
	"Colibris/middleware"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func LogRoutes(router *gin.RouterGroup, db *gorm.DB) {

	logService := service.NewLogService(db)
	logController := controller.NewLogController(logService)
	AuthMiddleware := middleware.AuthMiddleware

	logRoutes := router.Group("/backend/logs")
	{
		logRoutes.GET("", AuthMiddleware("ROLE_ADMIN"), logController.GetLogs)
	}
}
