package route

import (
	"Colibris/controller"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func LogRoutes(router *gin.RouterGroup, db *gorm.DB) {

	logService := service.NewLogService(db)
	logController := controller.NewLogController(logService)

	logRoutes := router.Group("/backend/logs")
	{
		//logRoutes.POST("", logController.CreateLog)
		logRoutes.GET("", logController.GetLogs)
	}
}
