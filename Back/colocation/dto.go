package colocations

type ColocationCreateRequest struct {
	Name        string `json:"name" binding:"required"`
	UserId      uint   `json:"userId" binding:"required"`
	Description string `json:"description"`
	IsPermanent bool   `json:"isPermanent"`
	Address     string `json:"address" binding:"required"`
	City        string `json:"city" binding:"required"`
	ZipCode     string `json:"zipCode" binding:"required"`
	Country     string `json:"country" binding:"required"`
}
