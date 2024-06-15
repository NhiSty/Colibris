package middleware

import (
	"Colibris/logs"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"time"
)

func LoggerMiddleware(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		startTime := time.Now()
		c.Next()

		adjustedTime := startTime.Add(2 * time.Hour)
		date := adjustedTime.Format("2006-01-02")
		timeOfDay := adjustedTime.Format("15h04 05s")

		status := c.Writer.Status()
		method := c.Request.Method
		path := c.Request.URL.Path
		clientIP := c.ClientIP()

		logLevel := "INFO"
		if status >= 400 && status < 500 {
			logLevel = "ERROR"
		} else if status >= 500 {
			logLevel = "ERROR"
		}

		log := logs.Log{
			Method:   method,
			Path:     path,
			ClientIP: clientIP,
			Date:     date,
			Time:     timeOfDay,
			Level:    logLevel,
			Status:   status,
		}

		db.Create(&log)
	}
}
