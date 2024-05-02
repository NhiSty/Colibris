package users

import (
	"gorm.io/gorm"
)

type UserRepository interface {
	AddUser(user *User) error
	GetUserByEmail(email string) (*User, error)
}

type userRepository struct {
	db *gorm.DB
}

func (r *userRepository) GetUserByEmail(email string) (*User, error) {
	var user User
	result := r.db.Where("email = ?", email).First(&user)
	return &user, result.Error
}

func NewUserRepository(db *gorm.DB) UserRepository {
	return &userRepository{db: db}
}

func (r *userRepository) AddUser(user *User) error {
	return r.db.Create(user).Error
}
