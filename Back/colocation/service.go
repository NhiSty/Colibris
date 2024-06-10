package colocations

import "Colibris/models"

type ColocationService struct {
	repo ColocationRepository
}

func NewColocationService(repo ColocationRepository) ColocationService {
	return ColocationService{repo: repo}
}

func (s *ColocationService) createColocation(colocation *models.Colocation) error {
	return s.repo.CreateColocation(colocation)
}

func (s *ColocationService) getColocationById(id int) (*models.Colocation, error) {
	return s.repo.GetColocationById(id)
}

func (s *ColocationService) GetAllUserColocations(userId int) ([]models.Colocation, error) {
	return s.repo.GetAllUserColocations(userId)
}

func (s *ColocationService) UpdateColocation(id int, colocationUpdates map[string]interface{}) (*models.Colocation, error) {
	return s.repo.UpdateColocation(id, colocationUpdates)
}

func (s *ColocationService) DeleteColocation(id int) error {
	return s.repo.DeleteColocation(id)
}
