package service

import (
	"Colibris/model"
	"errors"
	"fmt"
	"gorm.io/gorm"
)

type InvitationService struct {
	db *gorm.DB
}

func NewInvitationService(db *gorm.DB) InvitationService {
	return InvitationService{db: db}
}

func (s *InvitationService) GetAllUserInvitation(id int) ([]model.Invitation, error) {
	var invitation []model.Invitation

	result := s.db.Where("user_id = ?", id).Where("state = ?", "pending").Find(&invitation)

	if result.Error != nil {
		return nil, result.Error
	}
	return invitation, nil
}

func (s *InvitationService) CreateInvitation(invitation *model.Invitation) error {

	var colocation model.Colocation
	if err := s.db.Where("id = ?", invitation.ColocationID).First(&colocation).Error; err != nil {
		return err
	}

	var user model.User
	if err := s.db.Where("id = ?", invitation.UserID).First(&user).Error; err != nil {
		return err
	}

	for _, member := range colocation.ColocMembers {
		if member.UserID == user.ID {
			return errors.New("user is already a member of the colocation")
		}
	}

	return s.db.Create(invitation).Error
}

func (s *InvitationService) UpdateInvitation(id int, state string) (*model.Invitation, error) {
	invitationState := model.InvitationState(state)

	if invitationState != model.Pending && invitationState != model.Accepted && invitationState != model.Declined {
		return nil, fmt.Errorf("invalid state: %s", state)
	}

	var invitation model.Invitation
	if err := s.db.Where("id = ?", id).First(&invitation).Error; err != nil {
		return nil, err
	}

	invitation.State = invitationState
	if err := s.db.Save(&invitation).Error; err != nil {
		return nil, err
	}

	if invitationState == model.Accepted {
		var colocation model.Colocation
		if err := s.db.Where("id = ?", invitation.ColocationID).First(&colocation).Error; err != nil {
			return nil, err
		}

		var user model.User

		if err := s.db.Where("id = ?", invitation.UserID).First(&user).Error; err != nil {
			println("error", invitation.UserID)
			return nil, err
		}

		colocation.ColocMembers = append(colocation.ColocMembers, model.ColocMember{
			UserID:       user.ID,
			ColocationID: invitation.ColocationID,
		})

		if err := s.db.Save(&colocation).Error; err != nil {
			println("error 4 ")
			return nil, err
		}
	}

	return &invitation, nil
}

func (s *InvitationService) GetDB() *gorm.DB {
	return s.db
}
