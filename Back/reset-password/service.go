package reset_password

import (
	"Colibris/users"
	"errors"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type ResetPasswordService struct {
	repo     *ResetPasswordRepository
	userRepo users.UserRepository
}

func NewResetPasswordService(repo *ResetPasswordRepository, userRepo users.UserRepository) *ResetPasswordService {
	return &ResetPasswordService{repo: repo, userRepo: userRepo}
}

func (s *ResetPasswordService) SendResetLink(email string) (string, error) {
	_, err := s.userRepo.GetUserByEmail(email)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return "", errors.New("user not found")
		}
		return "", err
	} else {
		return s.repo.CreateToken(email)
	}

}

func (s *ResetPasswordService) ValidateResetToken(token string) (string, error) {
	return s.repo.ValidateToken(token)
}

func (s *ResetPasswordService) DeleteToken(token string) error {
	return s.repo.DeleteToken(token)
}

func (s *ResetPasswordService) ResetPassword(token string, newPassword string) (*users.User, error) {
	email, err := s.repo.ValidateToken(token)
	if err != nil {
		return nil, err
	}

	// Fetch the user by email
	user, err := s.userRepo.GetUserByEmail(email)
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

	updatedUser, err := s.userRepo.UpdateUser(user.ID, map[string]interface{}{
		"password": string(hashedPassword),
	})
	if err != nil {
		return nil, errors.New("failed to update password")
	}
	err = s.repo.DeleteToken(token)
	if err != nil {
		return nil, err
	}

	return updatedUser, nil
}
