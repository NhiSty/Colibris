package main

import (
	connector "Colibris/db"
	"Colibris/docs"
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

		//	v1.POST("/user", findByController)

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

/*
type Email struct {
	email string
}

func findByController(c *gin.Context) {
	var email Email
	err := c.ShouldBind(email)
	if err != nil {
		c.JSON(http.StatusUnprocessableEntity, gin.H{
			"message": "You must specify an email",
		})
	}
	fmt.Println(email)
	user, err := connector.GetUserByEmail(email.email)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{
			"message": "User not found",
		})
	} else {
		c.JSON(http.StatusOK, gin.H{
			"user": user,
		})
	}

}
*/
