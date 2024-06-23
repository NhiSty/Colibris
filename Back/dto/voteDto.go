package dto

type VoteCreateRequest struct {
	TaskID uint `json:"taskId" binding:"required"`
	Value  int  `json:"value" binding:"required"`
}
