package model

import "gorm.io/gorm"

type ColocMember struct {
	gorm.Model
	UserID       uint    `gorm:"not null"`
	ColocationID uint    `gorm:"not null"`
	Score        float32 `gorm:"not null"`
}
