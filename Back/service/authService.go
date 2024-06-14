package service

import (
	"Colibris/model"
	"errors"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type Service interface {
	Register(user *model.User) error
	Login(email, password string) (*model.User, error)
	GetUser(id uint) (*model.User, error)
}

type authService struct {
	db *gorm.DB
}

func NewAuthService(db *gorm.DB) Service {
	return &authService{db: db}
}

func (s *authService) Register(user *model.User) error {
	println(user.Password)
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	user.Password = string(hashedPassword)
	var userService = NewUserService(s.db)
	return userService.AddUser(user)
}

func (s *authService) Login(email, password string) (*model.User, error) {
	var userService = NewUserService(s.db)
	user, err := userService.GetUserByEmail(email)

	if err != nil {
		return nil, err

	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		println(err.Error())
		return nil, errors.New("invalid credentials")
	}
	return user, nil
}

func (s *authService) GetUser(id uint) (*model.User, error) {
	var userService = NewUserService(s.db)
	user, err := userService.GetUserById(id)
	if err != nil {
		return nil, err
	}
	return user, nil
}
