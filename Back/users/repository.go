package users

import (
	"gorm.io/gorm"
)

type UserRepository interface {
	AddUser(user *User) error
	GetAllUsers() ([]User, error)
	GetUserById(id any) (*User, error)
	GetUserByEmail(email string) (*User, error)
	UpdateUser(id uint, userUpdates map[string]interface{}) (*User, error)
	DeleteUserById(id uint) error
}

type userRepository struct {
	db *gorm.DB
}

func (r *userRepository) UpdateUser(id uint, userUpdates map[string]interface{}) (*User, error) {
	var user User
	if err := r.db.Model(&user).Where("id = ?", id).Updates(userUpdates).Error; err != nil {
		return nil, err
	}
	if err := r.db.Where("id = ?", id).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *userRepository) GetUserById(id any) (*User, error) {
	var user User
	result := r.db.Where("id = ?", id).First(&user)
	return &user, result.Error
}

func (r *userRepository) GetUserByEmail(email string) (*User, error) {
	var user User
	result := r.db.Where("email = ?", email).First(&user)
	return &user, result.Error
}

func (r *userRepository) DeleteUserById(id uint) error {
	return r.db.Delete(&User{}, id).Error
}

func (r *userRepository) GetAllUsers() ([]User, error) {
	var users []User
	result := r.db.Find(&users)
	return users, result.Error
}

func NewUserRepository(db *gorm.DB) UserRepository {
	return &userRepository{db: db}
}

func (r *userRepository) AddUser(user *User) error {
	return r.db.Create(user).Error
}
