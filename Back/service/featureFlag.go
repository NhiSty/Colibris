package service

import (
	"Colibris/model"
	"gorm.io/gorm"
)

type FeatureFlagService struct {
	db *gorm.DB
}

func NewFeatureFlagService(db *gorm.DB) *FeatureFlagService {
	return &FeatureFlagService{db: db}
}

func (f *FeatureFlagService) CreateFeatureFlag(flag *model.FeatureFlag) error {
	return f.db.Create(flag).Error
}

func (f *FeatureFlagService) GetFeatureFlags() ([]model.FeatureFlag, error) {
	var flags []model.FeatureFlag
	err := f.db.Order("created_at desc").Find(&flags).Error
	return flags, err
}

func (f *FeatureFlagService) GetFeatureFlagByID(id uint) (*model.FeatureFlag, error) {
	var flag model.FeatureFlag
	err := f.db.First(&flag, id).Error
	return &flag, err
}

func (f *FeatureFlagService) UpdateFeatureFlag(flag *model.FeatureFlag) error {
	return f.db.Save(flag).Error
}

func (f *FeatureFlagService) DeleteFeatureFlag(flag *model.FeatureFlag) error {
	return f.db.Delete(flag).Error
}
