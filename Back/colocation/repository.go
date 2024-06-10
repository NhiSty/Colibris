package colocations

import (
	"Colibris/models"
	"gorm.io/gorm"
)

type ColocationRepository interface {
	GetColocationById(id int) (*models.Colocation, error)
	CreateColocation(colocation *models.Colocation) error
	GetAllUserColocations(userId int) ([]models.Colocation, error)
	UpdateColocation(id int, colocationUpdates map[string]interface{}) (*models.Colocation, error)
	DeleteColocation(id int) error
}

type colocationRepository struct {
	db *gorm.DB
}

func (r *colocationRepository) GetColocationById(id int) (*models.Colocation, error) {
	var colocation models.Colocation
	result := r.db.Where("id = ?", id).First(&colocation)
	return &colocation, result.Error
}

func (r *colocationRepository) CreateColocation(colocation *models.Colocation) error {
	colocation.ColocMembers = append(colocation.ColocMembers, models.ColocMember{
		UserID:       colocation.UserID,
		ColocationID: colocation.ID,
	})
	return r.db.Create(colocation).Error
}

func (r *colocationRepository) GetAllUserColocations(userId int) ([]models.Colocation, error) {
	var colocations []models.Colocation
	result := r.db.Preload("ColocMembers").Find(&colocations)
	if result.Error != nil {
		return nil, result.Error
	}

	var filteredColocations []models.Colocation
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
func (r *colocationRepository) AddColocMember(colocation *models.Colocation) error {
	colocation.ColocMembers = append(colocation.ColocMembers, models.ColocMember{
		UserID:       colocation.UserID,
		ColocationID: colocation.ID,
	})
	return r.db.Save(colocation).Error
}

func NewColocationRepository(db *gorm.DB) ColocationRepository {
	return &colocationRepository{db: db}
}
func (r *colocationRepository) UpdateColocation(id int, colocationUpdates map[string]interface{}) (*models.Colocation, error) {
	var colocation models.Colocation
	if err := r.db.Model(&colocation).Where("id = ?", id).Updates(colocationUpdates).Error; err != nil {
		return nil, err
	}
	if err := r.db.Where("id = ?", id).First(&colocation).Error; err != nil {
		return nil, err
	}
	return &colocation, nil
}

func (r *colocationRepository) DeleteColocation(id int) error {
	return r.db.Delete(&models.Colocation{}, id).Error
}
