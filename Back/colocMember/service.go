package colocMembers

type ColocMemberService struct {
	repo ColocMemberRepository
}

func NewColocMemberService(repo ColocMemberRepository) ColocMemberService {
	return ColocMemberService{repo: repo}
}

func (s *ColocMemberService) CreateColocMember(colocMember *ColocMember) error {
	return s.repo.CreateColocMember(colocMember)
}

func (s *ColocMemberService) GetColocMemberById(id int) (*ColocMember, error) {
	return s.repo.GetColocMemberById(id)
}

func (s *ColocMemberService) GetAllColocMembers() ([]ColocMember, error) {
	return s.repo.GetAllColocMembers()
}

func (s *ColocMemberService) UpdateColocMemberScore(id int, newScore float32) error {
	return s.repo.UpdateColocMemberScore(id, newScore)
}
