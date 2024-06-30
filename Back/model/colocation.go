package model

import (
	"gorm.io/gorm"
)

type Colocation struct {
	gorm.Model
	Name         string `gorm:"not null"`
	UserID       uint
	ColocMembers []ColocMember `gorm:"foreignKey:ColocationID"`
	Description  string
	Location     string
	Latitude     float64
	Longitude    float64
	IsPermanent  bool
}
