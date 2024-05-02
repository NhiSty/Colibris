package users

import (
	"github.com/gin-gonic/gin"
)

type Controller struct{}

func (controller *Controller) GetAllUsers(c *gin.Context) {
	c.JSON(200, gin.H{
		"action": "get all users",
	})
}

func (controller *Controller) GetUserById(c *gin.Context) {
	id := c.Params.ByName("id")
	c.JSON(200, gin.H{
		"action": "get user by " + id,
	})
}
