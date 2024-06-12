package users

import (
	"gorm.io/gorm"
)

type UserRepository interface {
	AddUser(user *User) error
	GetAllUsers(page int, pageSize int) ([]User, int64, error)
	GetUserById(id any) (*User, error)
	GetUserByEmail(email string) (*User, error)
	UpdateUser(id uint, userUpdates map[string]interface{}) (*User, error)
	DeleteUserById(id uint) error
	SearchUsers(query string) ([]User, error)
}

type userRepository struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) UserRepository {
	return &userRepository{db: db}
}

func (r *userRepository) AddUser(user *User) error {
	return r.db.Create(user).Error
}

func (r *userRepository) GetAllUsers(page int, pageSize int) ([]User, int64, error) {
	var users []User
	var total int64

	r.db.Model(&User{}).Count(&total)

	if page == 0 || pageSize == 0 {
		result := r.db.Find(&users)
		return users, total, result.Error
	}

	offset := (page - 1) * pageSize
	result := r.db.Limit(pageSize).Offset(offset).Find(&users)
	return users, total, result.Error
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

func (r *userRepository) SearchUsers(query string) ([]User, error) {
	var users []User
	result := r.db.Where("firstname LIKE ? OR lastname LIKE ? OR email LIKE ?", "%"+query+"%", "%"+query+"%", "%"+query+"%").Find(&users)
	return users, result.Error
}
