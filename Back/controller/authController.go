package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"net/http"
	"strings"
)

type Controller struct {
	authService service.Service
}

func NewAuthController(authService service.Service) *Controller {
	return &Controller{authService: authService}
}

// Register a new user
// @Summary Register a new user
// @Description Register a new user
// @Tags auth
// @Accept json
// @Produce json
// @Param user body dto.UserRegistrationRequest true "User object"
// @Success 201 {object} dto.UserRegistrationRequest
// @Failure 400 {object} error
// @Router /auth/register [post]
func (ctl *Controller) Register(c *gin.Context) {
	var req dto.UserRegistrationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	user := model.User{
		Email:     req.Email,
		Password:  req.Password,
		Firstname: req.FirstName,
		Lastname:  req.LastName,
		Roles:     model.ROLE_USER,
	}
	if err := ctl.authService.Register(&user); err != nil {
		c.JSON(http.StatusFailedDependency, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, user)
}

// Login a user
// @Summary Login a user
// @Description Login a user
// @Tags auth
// @Accept json
// @Produce json
// @Param user body  dto.UserLoginRequest true "User object"
// @Success 200 {object} dto.UserLoginRequest
// @Failure 400 {object} error
// @Router /auth/login [post]
func (ctl *Controller) Login(c *gin.Context) {
	var req dto.UserLoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := ctl.authService.Login(req.Email, req.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid credentials"})
		return
	}
	token, err := service.GenerateJWT(user)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"token": token})
}

// Me returns the user information
// @Summary Get user information
// @Description Get user information
// @Tags auth
// @Accept json
// @Produce json
// @Success 200 {object} model.User
// @Failure 400 {object} error
// @Router /auth/me [get]
// @Security Bearer
func (ctl *Controller) Me(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "User ID not found in token claims"})
		return
	}
	user, err := ctl.authService.GetUser(userID.(uint))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, user)
}

func (ctl *Controller) ValidateToken(c *gin.Context) {
	var req dto.TokenRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var user *model.User
	var err error
	switch strings.ToLower(req.Provider) {
	case "google.com":
		user, err = ctl.authService.ValidateGoogleToken(req.Token)
	default:
		c.JSON(http.StatusBadRequest, gin.H{"error": "unsupported provider"})
		return
	}

	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid token"})
		return
	}
	email := user.Email

	existingUser, err := ctl.authService.GetUserByEmail(email)
	if err != nil {
		newUser := model.User{
			Email:     email,
			Password:  "",
			Firstname: user.Firstname,
			Lastname:  user.Lastname,
			Roles:     model.ROLE_USER,
		}

		if err := ctl.authService.Register(&newUser); err != nil {
			c.JSON(http.StatusFailedDependency, gin.H{"error": err.Error()})
			return
		}
		existingUser = &newUser
	}

	token, err := service.GenerateJWT(existingUser)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}
