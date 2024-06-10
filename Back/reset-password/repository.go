package reset_password

import (
	"Colibris/models"
	"errors"
	"gorm.io/gorm"
	"math/rand"
	"time"
)

type ResetPasswordRepository struct {
	db *gorm.DB
}

func NewResetPasswordRepository(db *gorm.DB) *ResetPasswordRepository {
	return &ResetPasswordRepository{db: db}
}

func (repo *ResetPasswordRepository) CreateToken(email string) (string, error) {
	token := generateToken()
	expiration := time.Now().Add(2 * time.Minute)
	resetPasswordToken := models.ResetPassword{
		Token:     token,
		Email:     email,
		ExpiresAt: expiration,
	}

	if err := repo.db.Create(&resetPasswordToken).Error; err != nil {
		return "", err
	}
	return token, nil
}

func (repo *ResetPasswordRepository) ValidateToken(token string) (string, error) {
	var resetPasswordToken models.ResetPassword
	result := repo.db.Where("token = ? AND expires_at > ?", token, time.Now()).First(&resetPasswordToken)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return "", errors.New("invalid or expired token")
	}
	return resetPasswordToken.Email, result.Error
}

func (repo *ResetPasswordRepository) DeleteToken(token string) error {
	return repo.db.Where("token = ?", token).Delete(&models.ResetPassword{}).Error
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
