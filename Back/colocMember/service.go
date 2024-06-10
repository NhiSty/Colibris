package colocMembers

import (
	"Colibris/models"
)

type ColocMemberService struct {
	repo ColocMemberRepository
}

type ColocMemberRepository interface {
	CreateColocMember(colocMember *models.ColocMember) error
	GetColocMemberById(id int) (*models.ColocMember, error)
	GetAllColocMembers() ([]models.ColocMember, error)
	UpdateColocMemberScore(id int, newScore float32) error
	GetColocationById(id int) (*models.Colocation, error)
	GetAllColocMembersByColoc(colocationId int) ([]models.ColocMember, error)
	DeleteColocMember(id int) error
}

func NewColocMemberService(repo ColocMemberRepository) ColocMemberService {
	return ColocMemberService{repo: repo}
}

func (s *ColocMemberService) CreateColocMember(colocMember *models.ColocMember) error {
	return s.repo.CreateColocMember(colocMember)
}

func (s *ColocMemberService) GetColocMemberById(id int) (*models.ColocMember, error) {
	return s.repo.GetColocMemberById(id)
}

func (s *ColocMemberService) GetAllColocMembers() ([]models.ColocMember, error) {
	return s.repo.GetAllColocMembers()
}

func (s *ColocMemberService) UpdateColocMemberScore(id int, newScore float32) error {
	return s.repo.UpdateColocMemberScore(id, newScore)
}

func (s *ColocMemberService) GetColocationById(id int) (*models.Colocation, error) {
	return s.repo.GetColocationById(id)
}

func (s *ColocMemberService) GetAllColocMembersByColoc(colocationId int) ([]models.ColocMember, error) {
	return s.repo.GetAllColocMembersByColoc(colocationId)
}

func (s *ColocMemberService) DeleteColocMember(id int) error {
	return s.repo.DeleteColocMember(id)
}
