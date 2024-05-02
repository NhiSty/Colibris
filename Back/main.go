package main

import (
	"Colibris/auth"
	"Colibris/users"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.Group("/api")
	auth.AuthRoutes(r)
	users.UserRoutes(r)
	r.Run(":8080")

}
