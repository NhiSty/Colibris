package model

import "gorm.io/gorm"

type Vote struct {
	gorm.Model
	ID     uint `gorm:"primaryKey"`
	UserID uint `gorm:"not null"`
	TaskID uint `gorm:"not null"`
	Value  int  `gorm:"not null"`
	User   User `gorm:"foreignKey:UserID" json:"-"`
	Task   Task `gorm:"foreignKey:TaskID" json:"-"`
}
