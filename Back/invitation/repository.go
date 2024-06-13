package invitations

import (
	"Colibris/models"
	"errors"
	"fmt"
	"gorm.io/gorm"
)

type InvitationRepository interface {
	CreateInvitation(invitation *models.Invitation) error
	GetAllUserInvitation(id int) ([]models.Invitation, error)
	UpdateInvitation(id int, state string) (*models.Invitation, error)
	GetUserById(id int) (*models.User, error)
	GetUserByEmail(email string) (*models.User, error)
}

type invitationRepository struct {
	db *gorm.DB
}

func (r *invitationRepository) GetUserById(id int) (*models.User, error) {
	var user models.User
	// print the db column names

	result := r.db.Find(&user, "id = ?", id)
	return &user, result.Error
}

func (r *invitationRepository) CreateInvitation(invitation *models.Invitation) error {
	// Find the colocation
	var colocation models.Colocation
	if err := r.db.Where("id = ?", invitation.ColocationID).First(&colocation).Error; err != nil {
		return err
	}

	// Find the user
	var user models.User
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

func (r *invitationRepository) GetAllUserInvitation(id int) ([]models.Invitation, error) {
	var invitation []models.Invitation

	result := r.db.Where("user_id = ?", id).Where("state = ?", "pending").Find(&invitation)

	if result.Error != nil {
		return nil, result.Error
	}
	return invitation, nil
}

func (r *invitationRepository) UpdateInvitation(id int, state string) (*models.Invitation, error) {
	// Convert state to InvitationState type
	invitationState := models.InvitationState(state)

	// Check if the state is valid
	if invitationState != models.Pending && invitationState != models.Accepted && invitationState != models.Declined {
		return nil, fmt.Errorf("invalid state: %s", state)
	}

	// Find the invitation
	var invitation models.Invitation
	if err := r.db.Where("id = ?", id).First(&invitation).Error; err != nil {
		return nil, err
	}

	// Update the invitation state
	invitation.State = invitationState
	if err := r.db.Save(&invitation).Error; err != nil {
		return nil, err
	}

	// If the invitation is accepted, add the user to the colocation
	if invitationState == models.Accepted {
		// Find the colocation
		var colocation models.Colocation
		if err := r.db.Where("id = ?", invitation.ColocationID).First(&colocation).Error; err != nil {
			return nil, err
		}

		// Find the user using their id
		var user models.User

		if err := r.db.Where("id = ?", invitation.UserID).First(&user).Error; err != nil {
			println("error 3 ", invitation.UserID)
			return nil, err
		}

		// Add the user to the colocation's members
		colocation.ColocMembers = append(colocation.ColocMembers, models.ColocMember{
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

func (r *invitationRepository) GetUserByEmail(email string) (*models.User, error) {
	var user models.User
	result := r.db.Where("email = ?", email).First(&user)
	return &user, result.Error
}

func NewInvitationRepository(db *gorm.DB) InvitationRepository {
	return &invitationRepository{db: db}
}
