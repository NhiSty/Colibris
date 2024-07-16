package tests

import (
	"Colibris/middleware"
	"Colibris/model"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"testing"
)

var user = &model.User{
	Email:     "admin@example.com",
	Firstname: "Admin",
	Lastname:  "User",
	Roles:     model.ROLE_ADMIN,
}

func TestGenerateJWT(t *testing.T) {
	tokenString, err := service.GenerateJWT(user)
	assert.NoError(t, err)
	assert.NotEmpty(t, tokenString)
}

func TestVerifyJWT(t *testing.T) {
	tokenString, err := service.GenerateJWT(user)
	assert.NoError(t, err)

	token, err := service.VerifyJWT(tokenString)
	assert.NoError(t, err)
	assert.NotNil(t, token)
	assert.True(t, token.Valid)
}

func TestDecodeJWT(t *testing.T) {
	tokenString, err := service.GenerateJWT(user)
	assert.NoError(t, err)

	claims, err := service.DecodeJWT(tokenString)
	assert.NoError(t, err)
	assert.NotNil(t, claims)
	assert.Equal(t, float64(user.ID), claims["user_id"])
	assert.Equal(t, user.Email, claims["email"])
	assert.Equal(t, user.Firstname, claims["first_name"])
	assert.Equal(t, user.Lastname, claims["last_name"])
	assert.Equal(t, user.Roles.String(), claims["role"])
}

func TestIsAdmin(t *testing.T) {
	tokenString, err := service.GenerateJWT(user)
	assert.NoError(t, err)

	claims, err := service.DecodeJWT(tokenString)
	assert.NoError(t, err)

	c := &gin.Context{}
	c.Set("role", claims["role"])

	isAdmin := service.IsAdmin(c)
	assert.True(t, isAdmin)

	user.Roles = model.ROLE_USER
	tokenString, err = service.GenerateJWT(user)
	assert.NoError(t, err)

	claims, err = service.DecodeJWT(tokenString)
	assert.NoError(t, err)

	c.Set("role", claims["role"])

	isAdmin = service.IsAdmin(c)
	assert.False(t, isAdmin)
}

func TestAuthMiddleware(t *testing.T) {
	tokenString, err := service.GenerateJWT(user)
	assert.NoError(t, err)

	gin.SetMode(gin.TestMode)
	r := gin.New()
	r.Use(middleware.AuthMiddleware())
	r.GET("/test", func(c *gin.Context) {
		c.String(http.StatusOK, "success")
	})

	req, _ := http.NewRequest(http.MethodGet, "/test", nil)
	req.Header.Set("Authorization", "Bearer "+tokenString)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)

	c, _ := gin.CreateTestContext(w)
	c.Request = req

	c.Request.Header.Set("Authorization", "Bearer "+tokenString)
	authMiddleware := middleware.AuthMiddleware()
	authMiddleware(c)

	userID, exists := c.Get("userID")
	assert.True(t, exists)
	assert.Equal(t, user.ID, userID)

	role, exists := c.Get("role")
	assert.True(t, exists)
	assert.Equal(t, user.Roles.String(), role)

	email, exists := c.Get("email")
	assert.True(t, exists)
	assert.Equal(t, user.Email, email)

	firstName, exists := c.Get("firstName")
	assert.True(t, exists)
	assert.Equal(t, user.Firstname, firstName)

	lastName, exists := c.Get("lastName")
	assert.True(t, exists)
	assert.Equal(t, user.Lastname, lastName)
}
