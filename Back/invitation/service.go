package invitations

import "Colibris/users"

type InvitationService struct {
	repo InvitationRepository
}

func NewInvitationService(repo InvitationRepository) InvitationService {
	return InvitationService{repo: repo}
}

func (s *InvitationService) GetAllUserInvitation(id int) ([]Invitation, error) {
	return s.repo.GetAllUserInvitation(id)
}

func (s *InvitationService) CreateInvitation(invitation *Invitation) error {
	return s.repo.CreateInvitation(invitation)
}

func (s *InvitationService) UpdateInvitation(id int, state string) (*Invitation, error) {
	return s.repo.UpdateInvitation(id, state)
}

func (s *InvitationService) GetUserById(id int) (*users.User, error) {
	return s.repo.GetUserById(id)
}

func (s *InvitationService) GetUserByEmail(email string) (*users.User, error) {
	return s.repo.GetUserByEmail(email)
}
