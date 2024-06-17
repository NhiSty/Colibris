// @title Swagger Example API
// @version 2.0
// @description This is a sample server for a pet store.
// @termsOfService http://swagger.io/terms/
// @host localhost:8080
// @securityDefinitions.apikey Bearer
// @in header
// @name Authorization
// @description Type "Bearer" followed by a space and JWT token.
package main

import (
	"Colibris/db"
	"Colibris/docs"
	"Colibris/middleware"
	"Colibris/route"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/joho/godotenv/autoload"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func main() {
	r := gin.Default()

	config := cors.Config{
		AllowOrigins:     []string{"*"}, // Frontend origin
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
	}

	database := db.Connect()
	db.Migrate(database)

	r.Use(cors.New(config))
	r.Use(middleware.LoggerMiddleware(database))

	const prefixUrl string = "/api/v1"
	docs.SwaggerInfo.BasePath = prefixUrl
	docs.SwaggerInfo.Schemes = []string{"http", "https"}

	v1 := r.Group(prefixUrl)
	{
		route.AuthRoutes(v1, database)
		route.UserRoutes(v1, database)
		route.ResetPasswordRoutes(v1, database)
		route.InvitationRoutes(v1, database)
		route.ColocMemberRoutes(v1, database)
		route.ColocationRoutes(v1, database)
		route.LogRoutes(v1, database)
		route.TaskRoutes(v1, database)
		route.ChatRoutes(v1, database)
		v1.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))
	}
	env := gin.Mode()

	if env == "prod" {
		gin.SetMode(gin.ReleaseMode)
		r.Use(gin.Recovery())
		err := r.Run(":80")
		if err != nil {
			return
		}
	}
	err := r.Run(":8080")
	if err != nil {
		return
	}
}
