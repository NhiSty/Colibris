package reset_password

import (
	"Colibris/services"
	"github.com/gin-gonic/gin"
	"net/http"
)

type ResetPasswordController struct {
	service *ResetPasswordService
}

func NewResetPasswordController(service *ResetPasswordService) *ResetPasswordController {
	return &ResetPasswordController{service: service}
}

func (ctl *ResetPasswordController) ForgotPassword(c *gin.Context) {
	var req ForgotPasswordRequest
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

	_, err = services.SendResetPasswordEmail("daossama.98@gmail.com", "test", token)
	// Envoyer l'email avec le lien de réinitialisation ici

	c.Status(http.StatusOK) // Réponse 200 sans message
}

func (ctl *ResetPasswordController) AskResetPassword(c *gin.Context) {
	token := c.Param("token")

	_, err := ctl.service.ValidateResetToken(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired token"})
		return
	}

	c.Status(http.StatusOK) // Réponse 200 sans message
}

func (ctl *ResetPasswordController) ResetPassword(c *gin.Context) {
	var req ResetPasswordRequest
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

	c.Status(http.StatusOK) // Réponse 200 sans message
}
