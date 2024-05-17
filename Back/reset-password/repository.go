package reset_password

import (
	"errors"
	"gorm.io/gorm"
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
	expiration := time.Now().Add(1 * time.Hour)
	resetPasswordToken := ResetPassword{
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
	var resetPasswordToken ResetPassword
	result := repo.db.Where("token = ? AND expires_at > ?", token, time.Now()).First(&resetPasswordToken)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return "", errors.New("invalid or expired token")
	}
	return resetPasswordToken.Email, result.Error
}

func (repo *ResetPasswordRepository) DeleteToken(token string) error {
	return repo.db.Where("token = ?", token).Delete(&ResetPassword{}).Error
}

func generateToken() string {
	// Générer un jeton aléatoire (vous pouvez utiliser une bibliothèque pour cela)
	return "randomlyGeneratedToken"
}
