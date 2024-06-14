package controller

import (
	"Colibris/dto"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"net/http"
)

type ResetPasswordController struct {
	service *service.ResetPasswordService
}

func NewResetPasswordController(service *service.ResetPasswordService) *ResetPasswordController {
	return &ResetPasswordController{
		service: service,
	}
}

// ForgotPassword sends a reset password link to the user's email
// @Summary Send a reset password link to the user's email
// @Description Send a reset password link to the user's email
// @Tags reset-password
// @Accept json
// @Produce json
// @Param userUpdates body dto.ForgotPasswordRequest true "User object"
// @Success 200
// @Failure 400 {object} error
// @Router /reset-password/forgot [post]
func (ctl *ResetPasswordController) ForgotPassword(c *gin.Context) {
	var req dto.ForgotPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token, err := ctl.service.SendResetLink(req.Email)
	if err != nil {
		if err.Error() == "user not found" {
			c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}

	_, err = service.SendResetPasswordEmail(req.Email, "test", token)

	c.Status(http.StatusOK)
}

// AskResetPassword checks if the reset token is valid
// @Summary Check if the reset token is valid
// @Description Check if the reset token is valid
// @Tags reset-password
// @Accept json
// @Produce json
// @Param token path string true "Reset token"
// @Success 200
// @Failure 401 {object} error
// @Router /reset-password/ask/{token} [get]
func (ctl *ResetPasswordController) AskResetPassword(c *gin.Context) {
	token := c.Param("token")

	_, err := ctl.service.ValidateResetToken(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired token"})
		return
	}

	c.Status(http.StatusOK)
}

// ResetPassword resets the user's password
// @Summary Reset the user's password
// @Description Reset the user's password
// @Tags reset-password
// @Accept json
// @Produce json
// @Param resetPassword body dto.ResetPasswordRequest true "User object"
// @Success 200
// @Failure 400 {object} error
// @Router /reset-password [post]
func (ctl *ResetPasswordController) ResetPassword(c *gin.Context) {
	var req dto.ResetPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	_, err := ctl.service.ResetPassword(req.Token, req.NewPassword)
	if err != nil {
		if err.Error() == "user not found" {
			c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		} else if err.Error() == "invalid or expired token" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired token"})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
		return
	}

	c.Status(http.StatusOK)
}
