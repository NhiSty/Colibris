package main

import (
	"Colibris/PostType"
	connector "Colibris/db"
	"Colibris/docs"
	"fmt"
	"github.com/gin-gonic/gin"
	_ "github.com/joho/godotenv/autoload"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	"net/http"
	"os"
)

func main() {

	r := gin.Default()
	docs.SwaggerInfo.BasePath = "/api/v1"
	docs.SwaggerInfo.Schemes = []string{"http", "https"}

	connector.Migrate()

	v1 := r.Group("/api/v1")
	{
		v1.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))
		v1.GET("/", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{
				"message": "Welcome to the API",
			})
		})
		v1.GET("/ping", pingController)

		v1.POST("/user", findByController)

	}

	r.Run(":8080")

}

// @BasePath /api/v1
// PingExample godoc
// @Summary ping example with an env value
// @Schemes
// @Description ping example with an env value
// @Tags ping env value
// @Accept json
// @Produce json
// @Success 200 {string} string "Pong ! This is an env value : " {string}
// @Router /ping [get]
func pingController(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "Pong ! This is an env value : " + os.Getenv("Hello"),
	})
}

// @BasePath /api/v1
// UserExample godoc
// @Summary  retrieve an user
// @Schemes
// @Description Retrieve an user using his email
// @Tags post user email
// @Accept json
// @Produce json
// @Success 200 User object
// @Param email body string true "User email" SchemaExample({"email" : "test@test.com"})
// @Router /user [post]
func findByController(c *gin.Context) {
	var email PostType.Email
	err := c.ShouldBindJSON(&email)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}
	fmt.Println(email)
	user, err := connector.GetUserByEmail(email.Email)

	if err != nil {
		c.AbortWithStatus(http.StatusNotFound)
	} else {
		c.JSON(http.StatusOK, gin.H{
			"user": user,
		})
	}

}
