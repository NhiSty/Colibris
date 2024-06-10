package invitations

import (
	"Colibris/models"
)

type InvitationService struct {
	repo InvitationRepository
}

func NewInvitationService(repo InvitationRepository) InvitationService {
	return InvitationService{repo: repo}
}

func (s *InvitationService) GetAllUserInvitation(id int) ([]models.Invitation, error) {
	return s.repo.GetAllUserInvitation(id)
}

func (s *InvitationService) CreateInvitation(invitation *models.Invitation) error {
	return s.repo.CreateInvitation(invitation)
}

func (s *InvitationService) UpdateInvitation(id int, state string) (*models.Invitation, error) {
	return s.repo.UpdateInvitation(id, state)
}

func (s *InvitationService) GetUserById(id int) (*models.User, error) {
	return s.repo.GetUserById(id)
}

func (s *InvitationService) GetUserByEmail(email string) (*models.User, error) {
	return s.repo.GetUserByEmail(email)
}
