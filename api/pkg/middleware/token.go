package middleware

import (
	"github.com/acme-sky/acmebank-api/pkg/config"
	"github.com/gin-gonic/gin"
	"net/http"
)

// Check the authorization from the header token. It must be the same of
// API_TOKEN env variable.
func Auth() gin.HandlerFunc {
	return func(c *gin.Context) {
		config, _ := config.GetConfig()
		bearer := c.Request.Header.Get("X-API-Token")
		if config.String("api.token") != bearer {
			c.JSON(http.StatusUnauthorized, gin.H{"message": "unauthorized"})

			c.Abort()
			return
		}
	}
}
