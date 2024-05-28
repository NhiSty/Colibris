package invitations

import (
	"database/sql/driver"
	"errors"
	"gorm.io/gorm"
)

type Invitation struct {
	gorm.Model
	UserID       uint
	ColocationID uint
	State        InvitationState `gorm:"type:varchar(20);not null"`
}

type InvitationState string

// Define the possible values
const (
	Pending  InvitationState = "pending"
	Accepted InvitationState = "accepted"
	Declined InvitationState = "declined"
)

func (s InvitationState) String() string {
	return string(s)
}

func (s *InvitationState) Scan(value interface{}) error {
	str, ok := value.(string)
	if !ok {
		return errors.New("type assertion to string failed")
	}
	*s = InvitationState(str)
	return nil
}

func (s InvitationState) Value() (driver.Value, error) {
	return string(s), nil
}
