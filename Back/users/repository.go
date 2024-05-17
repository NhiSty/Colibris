package users

import (
	"gorm.io/gorm"
)

type UserRepository interface {
	AddUser(user *User) error
	GetUserByEmail(email string) (*User, error)
	GetUserById(id any) (*User, error)
	UpdateUser(user *User) (*User, error)
}

type userRepository struct {
	db *gorm.DB
}

func (r *userRepository) UpdateUser(user *User) (*User, error) {
	result := r.db.Save(user)
	if result.Error != nil {
		return nil, result.Error
	}
	return user, nil
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

func NewUserRepository(db *gorm.DB) UserRepository {
	return &userRepository{db: db}
}

func (r *userRepository) AddUser(user *User) error {
	return r.db.Create(user).Error
}
