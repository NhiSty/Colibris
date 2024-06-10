package colocMembers

import (
	"Colibris/interfaces"
	"Colibris/models"
	"gorm.io/gorm"
)

type colocMemberRepository struct {
	db             *gorm.DB
	colocationRepo interfaces.ColocationRepository // Interface instead of direct import
}

func (r *colocMemberRepository) DeleteColocMember(id int) error {
	return r.db.Delete(&models.ColocMember{}, id).Error
}

func (r *colocMemberRepository) CreateColocMember(colocMember *models.ColocMember) error {
	return r.db.Create(colocMember).Error
}

func (r *colocMemberRepository) GetColocMemberById(id int) (*models.ColocMember, error) {
	var colocMember models.ColocMember
	result := r.db.Where("id = ?", id).First(&colocMember)
	return &colocMember, result.Error
}

func (r *colocMemberRepository) GetAllColocMembers() ([]models.ColocMember, error) {
	var colocMembers []models.ColocMember
	result := r.db.Find(&colocMembers)
	return colocMembers, result.Error
}

func (r *colocMemberRepository) UpdateColocMemberScore(id int, newScore float32) error {
	var colocMember models.ColocMember
	result := r.db.First(&colocMember, id)
	if result.Error != nil {
		return result.Error
	}
	colocMember.Score = newScore
	return r.db.Save(&colocMember).Error
}

func (r *colocMemberRepository) GetAllColocMembersByColoc(colocationId int) ([]models.ColocMember, error) {
	var colocMembers []models.ColocMember
	result := r.db.Where("colocation_id = ?", colocationId).Find(&colocMembers)
	return colocMembers, result.Error
}

func (r *colocMemberRepository) GetColocationById(id int) (*models.Colocation, error) {
	return r.colocationRepo.GetColocationById(id)
}

func NewColocMemberRepository(db *gorm.DB, colocationRepo interfaces.ColocationRepository) interfaces.ColocMemberRepository {
	return &colocMemberRepository{db: db, colocationRepo: colocationRepo}
}
