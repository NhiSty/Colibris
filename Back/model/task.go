package model

import "gorm.io/gorm"

type Task struct {
	gorm.Model
	Title        string `gorm:"not null"`
	Description  string
	UserID       uint   `gorm:"not null"`
	ColocationID uint   `gorm:"not null"`
	Date         string `gorm:"not null"`
	Duration     uint   `gorm:"not null"`
	Picture      string
	User         User       `gorm:"foreignKey:UserID" json:"-"`
	Colocation   Colocation `gorm:"foreignKey:ColocationID" json:"-"`
	Pts          uint       `gorm:"not null"`
}
