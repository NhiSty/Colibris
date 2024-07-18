package middleware

import (
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"net/http"
	"strings"
)

var RoleWeights = map[string]int{
	"ROLE_USER":  1,
	"ROLE_ADMIN": 2,
}

func AuthMiddleware(requiredRoles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization header is required"})
			c.Abort()
			return
		}

		const bearerPrefix = "Bearer "
		if !strings.HasPrefix(authHeader, bearerPrefix) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization header must start with Bearer"})
			c.Abort()
			return
		}

		tokenString := authHeader[len(bearerPrefix):]
		token, err := service.VerifyJWT(tokenString)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired JWT", "details": err.Error()})
			c.Abort()
			return
		}

		if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
			userID := uint(claims["user_id"].(float64))
			userRole := claims["role"].(string)

			// Check if the user has a high enough role weight if a required role is specified
			if len(requiredRoles) > 0 {
				requiredRole := requiredRoles[0]
				if RoleWeights[userRole] < RoleWeights[requiredRole] {
					c.JSON(http.StatusForbidden, gin.H{"error": "You do not have permission to access this route"})
					c.Abort()
					return
				}
			}

			c.Set("userID", userID)
			c.Set("role", userRole)
			c.Set("email", claims["email"])
			c.Set("firstName", claims["first_name"])
			c.Set("lastName", claims["last_name"])
			c.Set("fcmToken", claims["fcm_token"])
			c.Next()
		} else {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token claims"})
			c.Abort()
		}
	}
}
