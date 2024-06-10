package auth

import (
	"Colibris/models"
	"Colibris/users"
	"errors"
	"golang.org/x/crypto/bcrypt"
)

type Service interface {
	Register(user *models.User) error
	Login(email, password string) (*models.User, error)
	GetUser(id any) (*models.User, error)
}

type authService struct {
	userRepo users.UserRepository
}

func NewAuthService(userRepo users.UserRepository) Service {
	return &authService{userRepo: userRepo}
}

func (s *authService) Register(user *models.User) error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	user.Password = string(hashedPassword)
	return s.userRepo.AddUser(user)
}

func (s *authService) Login(email, password string) (*models.User, error) {
	user, err := s.userRepo.GetUserByEmail(email)
	if err != nil {
		return nil, err
	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return nil, errors.New("invalid credentials")
	}
	return user, nil
}

func (s *authService) GetUser(id any) (*models.User, error) {
	user, err := s.userRepo.GetUserById(id)
	if err != nil {
		return nil, err
	}
	return user, nil
}
