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
	IsMemberOfColocation(userID uint, colocationID uint) (bool, error)
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

func (s *ColocMemberService) GetColocMemberByUserId(userId int) (*model.ColocMember, error) {
	var colocMember model.ColocMember
	result := s.db.Where("user_id = ?", userId).First(&colocMember)
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

	query = "%" + query + "%"

	s.db.Model(&model.ColocMember{}).
		Joins("LEFT JOIN users ON users.id = coloc_members.user_id").
		Joins("LEFT JOIN colocations ON colocations.id = coloc_members.colocation_id").
		Where("users.firstname LIKE ? OR users.lastname LIKE ? OR colocations.name LIKE ?", query, query, query).
		Count(&total)

	offset := (page - 1) * pageSize
	result := s.db.Joins("LEFT JOIN users ON users.id = coloc_members.user_id").
		Joins("LEFT JOIN colocations ON colocations.id = coloc_members.colocation_id").
		Where("users.firstname LIKE ? OR users.lastname LIKE ? OR colocations.name LIKE ?", query, query, query).
		Limit(pageSize).Offset(offset).Find(&colocMembers)

	return colocMembers, total, result.Error
}

func (s *ColocMemberService) IsMemberOfColocation(userID int, colocationID uint) (bool, error) {
	var count int64
	result := s.db.Model(&model.ColocMember{}).
		Where("user_id = ? AND colocation_id = ?", userID, colocationID).
		Count(&count)
	return count > 0, result.Error
}

func (s *ColocMemberService) GetDB() *gorm.DB {
	return s.db
}
