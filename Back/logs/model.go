package logs

import (
	"gorm.io/gorm"
)

type Log struct {
	gorm.Model
	Method   string
	Path     string
	ClientIP string
	Date     string
	Time     string
	Level    string
	Status   int
}
