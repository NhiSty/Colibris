package service

import (
	"Colibris/model"
	"gorm.io/gorm"
)

type ColocMemberService struct {
	db *gorm.DB
}

type ColocMemberRepository interface {
	CreateColocMember(colocMember *model.ColocMember) error
	GetColocMemberById(id int) (*model.ColocMember, error)
	GetAllColocMembers(page int, pageSize int) ([]model.ColocMember, int64, error)
	UpdateColocMemberScore(id int, newScore float32) error
	GetColocationById(id int) (*model.Colocation, error)
	GetAllColocMembersByColoc(colocationId int) ([]model.ColocMember, error)
	DeleteColocMember(id int) error
	SearchColocMembers(query string, page int, pageSize int) ([]model.ColocMember, int64, error)
}

func NewColocMemberService(db *gorm.DB) ColocMemberService {
	return ColocMemberService{db: db}
}

func (s *ColocMemberService) CreateColocMember(colocMember *model.ColocMember) error {
	return s.db.Create(colocMember).Error
}

func (s *ColocMemberService) GetColocMemberById(id int) (*model.ColocMember, error) {
	var colocMember model.ColocMember
	result := s.db.Where("id = ?", id).First(&colocMember)
	return &colocMember, result.Error
}

func (s *ColocMemberService) GetAllColocMembers(page int, pageSize int) ([]model.ColocMember, int64, error) {
	var colocMembers []model.ColocMember
	var total int64

	query := s.db.Model(&model.ColocMember{}).
		Joins("JOIN colocations ON colocations.id = coloc_members.colocation_id").
		Where("colocations.deleted_at IS NULL")

	query.Count(&total)
	if page == 0 || pageSize == 0 {
		result := query.Find(&colocMembers)
		return colocMembers, total, result.Error
	}

	offset := (page - 1) * pageSize
	result := query.Limit(pageSize).Offset(offset).Find(&colocMembers)
	return colocMembers, total, result.Error

}

func (s *ColocMemberService) UpdateColocMemberScore(id int, newScore float32) error {
	var colocMember model.ColocMember
	result := s.db.First(&colocMember, id)
	if result.Error != nil {
		return result.Error
	}
	colocMember.Score = newScore
	return s.db.Save(&colocMember).Error
}

func (s *ColocMemberService) GetAllColocMembersByColoc(colocationId int) ([]model.ColocMember, error) {
	var colocMembers []model.ColocMember
	result := s.db.Where("colocation_id = ?", colocationId).Find(&colocMembers)
	return colocMembers, result.Error
}

func (s *ColocMemberService) DeleteColocMember(id int) error {
	return s.db.Delete(&model.ColocMember{}, id).Error
}

func (s *ColocMemberService) SearchColocMembers(query string, page int, pageSize int) ([]model.ColocMember, int64, error) {
	var colocMembers []model.ColocMember
	var total int64

	s.db.Model(&model.ColocMember{}).Where("user_id LIKE ? OR colocation_id LIKE ?", "%"+query+"%", "%"+query+"%").Count(&total)
	offset := (page - 1) * pageSize
	result := s.db.Where("user_id LIKE ? OR colocation_id LIKE ?", "%"+query+"%", "%"+query+"%").Limit(pageSize).Offset(offset).Find(&colocMembers)
	return colocMembers, total, result.Error
}

func (s *ColocMemberService) GetDB() *gorm.DB {
	return s.db
}
