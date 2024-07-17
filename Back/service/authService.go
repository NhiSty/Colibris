package service

import (
	"Colibris/model"
	"Colibris/utils"
	"context"
	"errors"
	"fmt"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
	"strings"
)

type Service interface {
	Register(user *model.User) error
	Login(email, password string) (*model.User, error)
	GetUser(id uint) (*model.User, error)
	GetUserByEmail(email string) (*model.User, error)
	ValidateGoogleToken(token string) (*model.User, error)
}

type authService struct {
	db             *gorm.DB
	firebaseClient *utils.FirebaseClient
}

func NewAuthService(db *gorm.DB, firebaseClient *utils.FirebaseClient) Service {
	return &authService{db: db, firebaseClient: firebaseClient}
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

func (s *authService) GetUserByEmail(email string) (*model.User, error) {
	var userService = NewUserService(s.db)
	return userService.GetUserByEmail(email)
}

func (s *authService) ValidateGoogleToken(token string) (*model.User, error) {
	ctx := context.Background()

	tokenInfo, err := s.firebaseClient.AuthClient.VerifyIDToken(ctx, token)
	if err != nil {
		return nil, fmt.Errorf("failed to validate ID token: %v", err)
	}
	email, ok := tokenInfo.Claims["email"].(string)
	if !ok {
		return nil, fmt.Errorf("failed to extract email from token claims")
	}
	name, _ := tokenInfo.Claims["name"].(string)
	nameParts := strings.SplitN(name, " ", 2)
	firstname := nameParts[0]
	lastname := ""
	if len(nameParts) > 1 {
		lastname = nameParts[1]
	}
	user := &model.User{
		Email:     email,
		Firstname: firstname,
		Lastname:  lastname,
		Password:  "",
	}
	return user, nil
}
