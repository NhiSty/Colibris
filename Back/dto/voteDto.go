package dto

type VoteCreateRequest struct {
	TaskID uint `json:"taskId" binding:"required"`
	Value  int  `json:"value" binding:"required"`
	UserID uint `json:"userId" binding:"omitempty"`
}

type VoteUpdateRequest struct {
	Value int `json:"value" binding:"required"`
}
