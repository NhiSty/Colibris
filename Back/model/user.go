package model

import (
	"database/sql/driver"
	"errors"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	Email       string       `gorm:"unique;not null"`
	Password    string       `gorm:"not null"`
	Firstname   string       `gorm:"not null"`
	Lastname    string       `gorm:"not null"`
	Colocations []Colocation `gorm:"foreignkey:UserID"`
	Roles       Role         `gorm:"type:varchar(20);not null"`
}

type Role string

// Define the possible values
const (
	ROLE_ADMIN Role = "ROLE_ADMIN"
	ROLE_USER  Role = "ROLE_USER"
)

func (r Role) String() string {
	return string(r)
}

func (r *Role) Scan(value interface{}) error {
	str, ok := value.(string)
	if !ok {
		return errors.New("type assertion to string failed")
	}
	*r = Role(str)
	return nil
}

func (r Role) Value() (driver.Value, error) {
	return string(r), nil
}
