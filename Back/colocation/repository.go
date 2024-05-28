package colocations

import (
	colocMembers "Colibris/colocMember"
	"gorm.io/gorm"
)

type ColocationRepository interface {
	CreateColocation(colocation *Colocation) error
	GetColocationById(id int) (*Colocation, error)
	GetAllUserColocations(userId int) ([]Colocation, error) // New method
}

type colocationRepository struct {
	db *gorm.DB
}

func (r *colocationRepository) GetColocationById(id int) (*Colocation, error) {
	var colocation Colocation
	result := r.db.Where("id = ?", id).First(&colocation)
	return &colocation, result.Error
}

func (r *colocationRepository) CreateColocation(colocation *Colocation) error {
	colocation.ColocMembers = append(colocation.ColocMembers, colocMembers.ColocMember{
		UserID:       colocation.UserID,
		ColocationID: colocation.ID,
	})
	return r.db.Create(colocation).Error
}

func (r *colocationRepository) GetAllUserColocations(userId int) ([]Colocation, error) {
	var colocations []Colocation
	result := r.db.Preload("ColocMembers").Find(&colocations)
	if result.Error != nil {
		return nil, result.Error
	}

	var filteredColocations []Colocation
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
func (r *colocationRepository) AddColocMember(colocation *Colocation) error {
	colocation.ColocMembers = append(colocation.ColocMembers, colocMembers.ColocMember{
		UserID:       colocation.UserID,
		ColocationID: colocation.ID,
	})
	return r.db.Save(colocation).Error
}

func NewColocationRepository(db *gorm.DB) ColocationRepository {
	return &colocationRepository{db: db}
}
