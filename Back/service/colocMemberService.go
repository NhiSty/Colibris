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
	GetColocMemberByUserId(userId int) (*model.ColocMember, error)
	GetAllColocMembers() ([]model.ColocMember, error)
	UpdateColocMemberScore(id int, newScore float32) error
	GetColocationById(id int) (*model.Colocation, error)
	GetAllColocMembersByColoc(colocationId int) ([]model.ColocMember, error)
	DeleteColocMember(id int) error
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

func (s *ColocMemberService) GetColocMemberByUserId(userId int) (*model.ColocMember, error) {
	var colocMember model.ColocMember
	result := s.db.Where("user_id = ?", userId).First(&colocMember)
	return &colocMember, result.Error
}

func (s *ColocMemberService) GetAllColocMembers() ([]model.ColocMember, error) {
	var colocMembers []model.ColocMember
	result := s.db.Find(&colocMembers)
	return colocMembers, result.Error
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

func (s *ColocMemberService) GetDB() *gorm.DB {
	return s.db
}
