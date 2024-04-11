package main

import (
	"github.com/gin-gonic/gin"
	_ "github.com/joho/godotenv/autoload"
	"github.com/zc2638/swag"
	"log"
	"net/http"
	"os"
)

func main() {

	r := gin.Default()
	api := swag.New()

	r.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Last Challenge !!!"})
	})

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Pong ! This is an env value : " + os.Getenv("Hello"),
		})
	})

	api.Walk(func(path string, e *swag.Endpoint) {
		h := e.Handler.(http.Handler)
		path = swag.ColonPath(path)

		r.Handle(e.Method, path, gin.WrapH(h))
	})

	r.GET("/swagger/json", gin.WrapH(api.Handler()))
	r.GET("/swagger/ui/*any", gin.WrapH(swag.UIHandler("/swagger/ui", "/swagger/json", true)))

	log.Fatal(http.ListenAndServe(":8080", r))

}
