package auth

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type RegisterRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type Controller struct{}

// Login godoc
// @Summary User login
// @Description Log in a user by providing email and password.
// @Tags auth
// @Accept json
// @Produce json
// @Param body body LoginRequest true "Login Information"
// @Success 200 {object} map[string]interface{} "Returns user token and status"
// @Failure 400 {object} map[string]interface{} "Invalid email or password"
// @Router /auth/login [post]
func (ctl *Controller) Login(c *gin.Context) {
	var loginReq LoginRequest
	if err := c.ShouldBindJSON(&loginReq); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}
	// Add login logic here
	c.JSON(http.StatusOK, gin.H{"message": "Logged in successfully"})
}

// Register godoc
// @Summary User registration
// @Description Register a new user by providing email, username, and password.
// @Tags auth
// @Accept json
// @Produce json
// @Param body body RegisterRequest true "Registration Information"
// @Success 200 {object} map[string]interface{} "User registered successfully"
// @Failure 400 {object} map[string]interface{} "Invalid registration information"
// @Router /auth/register [post]
func (ctl *Controller) Register(c *gin.Context) {
	var registerReq RegisterRequest
	if err := c.ShouldBindJSON(&registerReq); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}
	// Add registration logic here
	c.JSON(http.StatusOK, gin.H{"message": "Registered successfully"})
}
