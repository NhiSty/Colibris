package invitations

import (
	colocMembers "Colibris/models"
	"errors"
	"fmt"
	"gorm.io/gorm"
)

type InvitationRepository interface {
	CreateInvitation(invitation *colocMembers.Invitation) error
	GetAllUserInvitation(id int) ([]colocMembers.Invitation, error)
	UpdateInvitation(id int, state string) (*colocMembers.Invitation, error)
	GetUserById(id int) (*colocMembers.User, error)
	GetUserByEmail(email string) (*colocMembers.User, error)
}

type invitationRepository struct {
	db *gorm.DB
}

func (r *invitationRepository) GetUserById(id int) (*colocMembers.User, error) {
	var user colocMembers.User
	// print the db column names

	result := r.db.Find(&user, "id = ?", id)
	return &user, result.Error
}

func (r *invitationRepository) CreateInvitation(invitation *colocMembers.Invitation) error {
	// Find the colocation
	var colocation colocMembers.Colocation
	if err := r.db.Where("id = ?", invitation.ColocationID).First(&colocation).Error; err != nil {
		return err
	}

	// Find the user
	var user colocMembers.User
	if err := r.db.Where("id = ?", invitation.UserID).First(&user).Error; err != nil {
		return err
	}

	// Verify that the user isn't already in the colocation
	for _, member := range colocation.ColocMembers {
		if member.UserID == user.ID {
			return errors.New("user is already a member of the colocation")
		}
	}

	// Create the invitation
	return r.db.Create(invitation).Error
}

func (r *invitationRepository) GetAllUserInvitation(id int) ([]colocMembers.Invitation, error) {
	var invitation []colocMembers.Invitation

	result := r.db.Where("user_id = ?", id).Where("state = ?", "pending").Find(&invitation)

	if result.Error != nil {
		return nil, result.Error
	}
	return invitation, nil
}

func (r *invitationRepository) UpdateInvitation(id int, state string) (*colocMembers.Invitation, error) {
	// Convert state to InvitationState type
	invitationState := colocMembers.InvitationState(state)

	// Check if the state is valid
	if invitationState != colocMembers.Pending && invitationState != colocMembers.Accepted && invitationState != colocMembers.Declined {
		return nil, fmt.Errorf("invalid state: %s", state)
	}

	// Find the invitation
	var invitation colocMembers.Invitation
	if err := r.db.Where("id = ?", id).First(&invitation).Error; err != nil {
		return nil, err
	}

	// Update the invitation state
	invitation.State = invitationState
	if err := r.db.Save(&invitation).Error; err != nil {
		return nil, err
	}

	// If the invitation is accepted, add the user to the colocation
	if invitationState == colocMembers.Accepted {
		// Find the colocation
		var colocation colocMembers.Colocation
		if err := r.db.Where("id = ?", invitation.ColocationID).First(&colocation).Error; err != nil {
			return nil, err
		}

		// Find the user using their id
		var user colocMembers.User

		if err := r.db.Where("id = ?", invitation.UserID).First(&user).Error; err != nil {
			println("error 3 ", invitation.UserID)
			return nil, err
		}

		// Add the user to the colocation's members
		colocation.ColocMembers = append(colocation.ColocMembers, colocMembers.ColocMember{
			UserID:       user.ID,
			ColocationID: invitation.ColocationID,
		})

		// Save the updated colocation
		if err := r.db.Save(&colocation).Error; err != nil {
			println("error 4 ")
			return nil, err
		}
	}

	return &invitation, nil
}

func (r *invitationRepository) GetUserByEmail(email string) (*colocMembers.User, error) {
	var user colocMembers.User
	result := r.db.Where("email = ?", email).First(&user)
	return &user, result.Error
}

func NewInvitationRepository(db *gorm.DB) InvitationRepository {
	return &invitationRepository{db: db}
}
