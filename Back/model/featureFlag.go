package model

import "gorm.io/gorm"

type FeatureFlag struct {
	gorm.Model
	Name  string
	Value bool
}
