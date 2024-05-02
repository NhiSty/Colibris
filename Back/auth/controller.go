package auth

import (
	"github.com/gin-gonic/gin"
)

type Controller struct{}

func (ac *Controller) Login(c *gin.Context) {
	c.JSON(200, gin.H{
		"action": "login",
	})
}

func (ac *Controller) Register(c *gin.Context) {
	c.JSON(200, gin.H{
		"action": "register",
	})
}
