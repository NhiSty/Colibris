package model

import (
	"gorm.io/gorm"
	"time"
)

type ResetPassword struct {
	gorm.Model
	Token     string
	Email     string
	ExpiresAt time.Time
}
