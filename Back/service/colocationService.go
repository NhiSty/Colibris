package service

import (
	"Colibris/model"
	"gorm.io/gorm"
)

type ColocationService struct {
	db *gorm.DB
}

func NewColocationService(db *gorm.DB) ColocationService {
	return ColocationService{db: db}
}

func (s *ColocationService) CreateColocation(colocation *model.Colocation) error {
	colocation.ColocMembers = append(colocation.ColocMembers, model.ColocMember{
		UserID:       colocation.UserID,
		ColocationID: colocation.ID,
	})
	return s.db.Create(colocation).Error
}

func (s *ColocationService) GetColocationById(id int) (*model.Colocation, error) {
	var colocation model.Colocation
	result := s.db.Preload("ColocMembers").Where("id = ?", id).First(&colocation)
	return &colocation, result.Error
}

func (s *ColocationService) GetAllUserColocations(userId int) ([]model.Colocation, error) {
	var colocations []model.Colocation
	result := s.db.Preload("ColocMembers").Find(&colocations)
	if result.Error != nil {
		return nil, result.Error
	}

	var filteredColocations []model.Colocation
	userIDUint := uint(userId)

	for _, colocation := range colocations {
		if colocation.UserID == userIDUint {
			filteredColocations = append(filteredColocations, colocation)
			continue
		}
		for _, member := range colocation.ColocMembers {
			if member.UserID == userIDUint {
				filteredColocations = append(filteredColocations, colocation)
				break
			}
		}
	}

	return filteredColocations, nil
}

func (s *ColocationService) UpdateColocation(id int, colocationUpdates map[string]interface{}) (*model.Colocation, error) {
	var colocation model.Colocation
	if err := s.db.Model(&colocation).Where("id = ?", id).Updates(colocationUpdates).Error; err != nil {
		return nil, err
	}
	if err := s.db.Where("id = ?", id).First(&colocation).Error; err != nil {
		return nil, err
	}
	return &colocation, nil
}

func (s *ColocationService) DeleteColocation(id int) error {
	return s.db.Delete(&model.Colocation{}, id).Error
}
