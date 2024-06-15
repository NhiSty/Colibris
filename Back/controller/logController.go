package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

type LogController struct {
	service *service.LogService
}

func NewLogController(service *service.LogService) *LogController {
	return &LogController{service: service}
}

func (controller *LogController) CreateLog(c *gin.Context) {
	var logDTO dto.LogDTO
	if err := c.ShouldBindJSON(&logDTO); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	log := model.Log{
		Method:   logDTO.Method,
		Path:     logDTO.Path,
		ClientIP: logDTO.ClientIP,
		Date:     logDTO.Date,
		Time:     logDTO.Time,
		Level:    logDTO.Level,
		Status:   logDTO.Status,
	}
	err := controller.service.CreateLog(&log)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "log created"})
}

func (controller *LogController) GetLogs(c *gin.Context) {
	logs, err := controller.service.GetLogs()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, logs)
}
