package colocations

type ColocationCreateRequest struct {
	Name        string `json:"name" binding:"required"`
	UserId      uint   `json:"userId" binding:"required"`
	Description string `json:"description"`
	IsPermanent bool   `json:"isPermanent" binding:"required"`
}
