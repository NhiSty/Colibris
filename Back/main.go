package main

import (
	"Colibris/auth"
	connector "Colibris/db"
	"Colibris/docs"
	"Colibris/users"
	"github.com/gin-gonic/gin"
	_ "github.com/joho/godotenv/autoload"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func main() {
	r := gin.Default()
	const prefixUrl string = "/api/v1"
	docs.SwaggerInfo.BasePath = prefixUrl
	docs.SwaggerInfo.Schemes = []string{"http", "https"}

	connector.Migrate()

	v1 := r.Group(prefixUrl)
	{
		auth.AuthRoutes(v1)
		users.UserRoutes(v1)
		v1.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))
	}
	r.Run(":8080")
}
