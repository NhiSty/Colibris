package tasks

import "gorm.io/gorm"

type Task struct {
	gorm.Model
	Title        string `gorm:"not null"`
	Description  string
	UserId       uint   `gorm:"not null"`
	ColocationId uint   `gorm:"not null"`
	Date         string `gorm:"not null"`
	Duration     uint   `gorm:"not null"`
	Picture      string
}
