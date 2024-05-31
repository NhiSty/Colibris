package users

import (
	colocations "Colibris/colocation"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	Email       string                   `gorm:"unique;not null"`
	Password    string                   `gorm:"not null"`
	Firstname   string                   `gorm:"not null"`
	Lastname    string                   `gorm:"not null"`
	Colocations []colocations.Colocation `gorm:"foreignkey:UserID"`
}
