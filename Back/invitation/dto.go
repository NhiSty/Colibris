package invitations

type InvitationCreateRequest struct {
	Email        string `json:"email" binding:"required"`
	ColocationID uint   `json:"colocationId" binding:"required"`
}

type InvitationUpdateRequest struct {
	State        string `json:"state" binding:"required"`
	InvitationId uint   `json:"invitationId" binding:"required"`
}
