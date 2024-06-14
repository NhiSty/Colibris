package dto

type ForgotPasswordRequest struct {
	Email string `json:"email" binding:"required,email"`
}

type AskResetPasswordRequest struct {
	Token string `json:"token" binding:"required"`
}

type ResetPasswordRequest struct {
	Token       string `json:"token" binding:"required"`
	NewPassword string `json:"new_password" binding:"required"`
}
