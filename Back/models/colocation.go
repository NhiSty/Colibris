package models

import (
	"gorm.io/gorm"
)

type Colocation struct {
	gorm.Model
	Name         string `gorm:"not null"`
	UserID       uint
	ColocMembers []ColocMember `gorm:"foreignKey:ColocationID"`
	Description  string
	Address      string
	City         string
	ZipCode      string
	Country      string
	IsPermanent  bool
}
