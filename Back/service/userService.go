package service

import (
	"Colibris/model"
	"gorm.io/gorm"
)

type UserService struct {
	db *gorm.DB
}

func NewUserService(db *gorm.DB) *UserService {
	return &UserService{
		db: db,
	}
}

func (s *UserService) GetAllUsers() ([]model.User, error) {
	var users []model.User
	result := s.db.Find(&users)
	return users, result.Error
}

func (s *UserService) GetUserById(id uint) (*model.User, error) {
	var user model.User
	result := s.db.Where("id = ?", id).First(&user)
	return &user, result.Error
}

func (s *UserService) GetUserByEmail(email string) (*model.User, error) {
	var user model.User
	result := s.db.Where("email = ?", email).First(&user)
	return &user, result.Error
}

func (s *UserService) UpdateUser(id uint, userUpdates map[string]interface{}) (*model.User, error) {
	var user model.User
	if err := s.db.Model(&user).Where("id = ?", id).Updates(userUpdates).Error; err != nil {
		return nil, err
	}
	if err := s.db.Where("id = ?", id).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func (s *UserService) DeleteUserById(id uint) error {
	return s.db.Delete(&model.User{}, id).Error
}

func (s *UserService) AddUser(user *model.User) error {
	return s.db.Create(user).Error
}
