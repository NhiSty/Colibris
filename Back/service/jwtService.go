package service

import (
	"Colibris/model"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"time"
)

var jwtKey = []byte("monSecretTrèsSecret")

func GenerateJWT(user *model.User) (string, error) {
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)

	claims["user_id"] = user.ID
	claims["exp"] = time.Now().Add(time.Hour * 24).Unix()
	claims["role"] = user.Roles.String()
	claims["email"] = user.Email
	claims["first_name"] = user.Firstname
	claims["last_name"] = user.Lastname
	claims["fcm_token"] = user.FcmToken

	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		return "", err
	}
	return tokenString, nil
}

func VerifyJWT(tokenString string) (*jwt.Token, error) {
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
		}
		return jwtKey, nil
	})

	if err != nil {
		return nil, err
	}

	return token, nil
}

func DecodeJWT(tokenString string) (jwt.MapClaims, error) {
	token, _, err := new(jwt.Parser).ParseUnverified(tokenString, jwt.MapClaims{})
	if err != nil {
		return nil, err
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok {
		return claims, nil
	}
	return nil, fmt.Errorf("Invalid token claims")
}

func IsAdmin(c *gin.Context) bool {
	roleFromToken, exists := c.Get("role")
	if !exists {
		return false
	}
	role, ok := roleFromToken.(string)
	if !ok {
		return false
	}
	if role != model.ROLE_ADMIN.String() {
		return false

	}
	return true
}
