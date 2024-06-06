package tasks

import (
	colocations "Colibris/colocation"
	"Colibris/users"
	"gorm.io/gorm"
)

type Task struct {
	gorm.Model
	Title        string `gorm:"not null"`
	Description  string
	UserID       uint   `gorm:"not null"`
	ColocationID uint   `gorm:"not null"`
	Date         string `gorm:"not null"`
	Duration     uint   `gorm:"not null"`
	Picture      string

	User       users.User             `gorm:"foreignKey:UserID" json:"-"`       // One to one relationship with User, JSON ignored
	Colocation colocations.Colocation `gorm:"foreignKey:ColocationID" json:"-"` // One to one relationship with Colocation, JSON ignored
}
