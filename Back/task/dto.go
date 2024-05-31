package tasks

type TaskCreateRequest struct {
	Title        string `json:"title" binding:"required"`
	Description  string `json:"description"`
	UserId       uint   `json:"userId" binding:"required"`
	ColocationId uint   `json:"colocationId" binding:"required"`
	Date         string `json:"date" binding:"required"`
	Duration     uint   `json:"duration" binding:"required"`
	Picture      string `json:"picture"`
}
