package colocations

import (
	colocMembers "Colibris/colocMember"
	"gorm.io/gorm"
)

type ColocationRepository interface {
	CreateColocation(colocation *Colocation) error
	GetColocationById(id int) (*Colocation, error)
	GetAllUserColocations(userId int) ([]Colocation, error) // New method
	GetAllColocations() ([]Colocation, error)               // New method
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

	return r.db.Create(colocation).Error
}

func (r *colocationRepository) GetAllUserColocations(userId int) ([]Colocation, error) {
	var colocations []Colocation
	result := r.db.Where("user_id = ?", userId).Find(&colocations)
	return colocations, result.Error
}
func (r *colocationRepository) GetAllColocations() ([]Colocation, error) {
	var colocations []Colocation
	result := r.db.Find(&colocations)
	return colocations, result.Error
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
