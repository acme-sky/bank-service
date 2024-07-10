package main

import (
	"log"

	"github.com/acme-sky/acmebank-api/internal/handlers"
	"github.com/acme-sky/acmebank-api/pkg/config"
	"github.com/acme-sky/acmebank-api/pkg/db"
	"github.com/acme-sky/acmebank-api/pkg/middleware"
	"github.com/gin-gonic/gin"
	cors "github.com/rs/cors/wrapper/gin"
)

// Create a new instance of Gin server
func main() {
	router := gin.Default()

	var err error

	// Read environment variables and stops execution if any errors occur
	err = config.LoadConfig()
	if err != nil {
		log.Printf("failed to load config. err %v", err)

		return
	}

	// Ignore error because if it failed on loading, it should raised an error
	// above.
	config, _ := config.GetConfig()

	if _, err := db.InitDb(config.String("database.dsn")); err != nil {
		log.Printf("failed to connect database. err %v", err)

		return
	}

	// Env variable `debug` set up the mode below
	if !config.Bool("debug") {
		gin.SetMode(gin.ReleaseMode)
	}

	router.Use(cors.Default())

	router.StaticFile("/swagger.yml", "cmd/swagger.yml")

	payments := router.Group("/payments")
	{
		payments.POST("/", middleware.Auth(), handlers.PaymentHandlerPost)
		payments.GET("/:id/", handlers.PaymentHandlerGetId)
		payments.POST("/:id/pay/", handlers.PaymentHandlerPay)
	}

	router.Run()
}
