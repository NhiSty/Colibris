// @title Swagger Example API
// @version 1.0
// @description This is a sample server for a pet store.
// @termsOfService http://swagger.io/terms/

// @host localhost:8080
// @BasePath /api/v1
package main

import (
	"Colibris/auth"
	colocMembers "Colibris/colocMember"
	colocations "Colibris/colocation"
	"Colibris/db"
	"Colibris/docs"
	"Colibris/reset-password"
	"Colibris/users"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/joho/godotenv/autoload"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func main() {
	r := gin.Default()

	//r.Use(cors.Default())
	config := cors.Config{
		AllowOrigins:     []string{"*"}, // Frontend origin
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
	}

	r.Use(cors.New(config))

	database := db.Connect()
	db.Migrate(database)

	const prefixUrl string = "/api/v1"
	docs.SwaggerInfo.BasePath = prefixUrl
	docs.SwaggerInfo.Schemes = []string{"http", "https"}

	v1 := r.Group(prefixUrl)
	{
		auth.Routes(v1, database)
		users.Routes(v1, database)
		colocations.Routes(v1, database)
		colocMembers.Routes(v1, database)
		reset_password.Routes(v1, database)
		v1.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))
	}
	r.Run(":8080")
}
