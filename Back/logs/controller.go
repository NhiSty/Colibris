package logs

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

type LogController struct {
	Service *LogService
}

func NewLogController(service *LogService) *LogController {
	return &LogController{Service: service}
}

func (controller *LogController) CreateLog(c *gin.Context) {
	var logDTO LogDTO
	if err := c.ShouldBindJSON(&logDTO); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	log := Log{
		Method:   logDTO.Method,
		Path:     logDTO.Path,
		ClientIP: logDTO.ClientIP,
		Date:     logDTO.Date,
		Time:     logDTO.Time,
		Level:    logDTO.Level,
		Status:   logDTO.Status,
	}
	err := controller.Service.CreateLog(&log)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "log created"})
}

func (controller *LogController) GetLogs(c *gin.Context) {
	logs, err := controller.Service.GetLogs()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, logs)
}
