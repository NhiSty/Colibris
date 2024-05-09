package auth

import (
	"Colibris/users"
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
)

type Controller struct {
	authService Service
}

func NewAuthController(authService Service) *Controller {
	return &Controller{authService: authService}
}

type ApiResponse struct {
	Success bool        `json:"success"`
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
	Error   string      `json:"error,omitempty"`
}

func (ctl *Controller) Register(c *gin.Context) {
	var req UserRegistrationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, ApiResponse{
			Success: false,
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}
	user := users.User{
		Email:     req.Email,
		Password:  req.Password,
		Firstname: req.FirstName,
		Lastname:  req.LastName,
	}
	if err := ctl.authService.Register(&user); err != nil {
		c.JSON(http.StatusInternalServerError, ApiResponse{
			Success: false,
			Message: "Failed to register user",
			Error:   err.Error(),
		})
		return
	}
	c.JSON(http.StatusCreated, ApiResponse{
		Success: true,
		Message: "User registered successfully",
		Data:    user,
	})
}

func (ctl *Controller) Login(c *gin.Context) {
	var req UserLoginRequest
	fmt.Print("req", req)
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, ApiResponse{
			Success: false,
			Message: "Invalid request data",
			Error:   err.Error(),
		})
		return
	}
	user, err := ctl.authService.Login(req.Email, req.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, ApiResponse{
			Success: false,
			Message: "Login failed",
			Error:   err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, ApiResponse{
		Success: true,
		Message: "Login successful",
		Data:    user,
	})
}
