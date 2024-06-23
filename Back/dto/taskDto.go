package dto

type TaskCreateRequest struct {
	Title        string `json:"title" binding:"required"`
	Description  string `json:"description"`
	UserId       uint   `json:"userId" binding:"required"`
	ColocationId uint   `json:"colocationId" binding:"required"`
	Date         string `json:"date" binding:"required"`
	Duration     uint   `json:"duration" binding:"required"`
	Picture      string `json:"picture"`
}

type TaskUpdateRequest struct {
	Title        string `json:"title,omitempty"`
	Description  string `json:"description,omitempty"`
	UserID       uint   `json:"user_id,omitempty"`
	ColocationID uint   `json:"colocation_id,omitempty"`
	Date         string `json:"date,omitempty"`
	Duration     uint   `json:"duration,omitempty"`
	Picture      string `json:"picture,omitempty"`
}
