package logs

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(router *gin.RouterGroup, db *gorm.DB) {
	repo := NewLogRepository(db)
	service := NewLogService(repo)
	controller := NewLogController(service)

	logRoutes := router.Group("/backend/logs")
	{
		logRoutes.POST("", controller.CreateLog)
		logRoutes.GET("", controller.GetLogs)
	}
}
