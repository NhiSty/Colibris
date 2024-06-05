package colocations

type ColocationService struct {
	repo ColocationRepository
}

func NewColocationService(repo ColocationRepository) ColocationService {
	return ColocationService{repo: repo}
}

func (s *ColocationService) createColocation(colocation *Colocation) error {
	return s.repo.CreateColocation(colocation)
}

func (s *ColocationService) getAllColocations() ([]Colocation, error) {
	return s.repo.GetAllColocations()
}
func (s *ColocationService) getColocationById(id int) (*Colocation, error) {
	return s.repo.GetColocationById(id)
}

func (s *ColocationService) GetAllUserColocations(userId int) ([]Colocation, error) {
	return s.repo.GetAllUserColocations(userId)
}
