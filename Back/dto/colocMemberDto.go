package dto

type ColocMemberCreateRequest struct {
	UserID       uint `json:"userId" binding:"required"`
	ColocationID uint `json:"colocationId" binding:"required"`
}

type ColocMemberScoreUpdateRequest struct {
	Score float32 `json:"score" binding:"required"`
}
