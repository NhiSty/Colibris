package service

import (
	"Colibris/model"
	"errors"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
	"math/rand"
	"time"
)

type ResetPasswordService struct {
	db *gorm.DB
}

func NewResetPasswordService(db *gorm.DB) *ResetPasswordService {
	return &ResetPasswordService{
		db: db,
	}
}

func (s *ResetPasswordService) SendResetLink(email string) (string, error) {
	var UserSvc = NewUserService(s.db)
	_, err := UserSvc.GetUserByEmail(email)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return "", errors.New("user not found")
		}
		return "", err
	} else {
		return s.CreateToken(email)
	}

}

func (s *ResetPasswordService) ValidateResetToken(token string) (string, error) {
	var resetPasswordToken model.ResetPassword
	result := s.db.Where("token = ? AND expires_at > ?", token, time.Now()).First(&resetPasswordToken)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return "", errors.New("invalid or expired token")
	}
	return resetPasswordToken.Email, result.Error
}

func (s *ResetPasswordService) DeleteToken(token string) error {
	return s.db.Where("token = ?", token).Delete(&model.ResetPassword{}).Error
}

// ResetPassword resets the password of a user
// @Summary Reset password
// @Description Reset password
// @Tags auth
// @Accept json
// @Produce json
// @Param token path string true "Reset token"
// @Param newPassword body string true "New password"
// @Success 200 {object} model.ResetPassword
// @Failure 400 {object} error
// @Router /auth/reset-password [post]
func (s *ResetPasswordService) ResetPassword(token string, newPassword string) (*model.User, error) {
	email, err := s.ValidateResetToken(token)
	if err != nil {
		return nil, err
	}

	var UserSvc = NewUserService(s.db)
	user, err := UserSvc.GetUserByEmail(email)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.DefaultCost)
	if err != nil {
		return nil, errors.New("failed to hash password")
	}

	updatedUser, err := UserSvc.UpdateUser(user.ID, map[string]interface{}{
		"password": string(hashedPassword),
	})
	if err != nil {
		return nil, errors.New("failed to update password")
	}
	err = s.DeleteToken(token)
	if err != nil {
		return nil, err
	}

	return updatedUser, nil
}

func (s *ResetPasswordService) CreateToken(email string) (string, error) {
	token := generateToken()
	expiration := time.Now().Add(2 * time.Minute)
	resetPasswordToken := model.ResetPassword{
		Token:     token,
		Email:     email,
		ExpiresAt: expiration,
	}

	if err := s.db.Create(&resetPasswordToken).Error; err != nil {
		return "", err
	}
	return token, nil
}

func generateToken() string {
	var charset = "0123456789"
	password := ""
	for i := 0; i < 6; i++ {
		randomIndex := rand.Intn(len(charset))
		password += string(charset[randomIndex])
	}
	return password
}
