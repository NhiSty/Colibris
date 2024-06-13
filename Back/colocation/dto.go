package colocations

type ColocationCreateRequest struct {
	Name        string  `json:"name" binding:"required"`
	UserId      uint    `json:"userId" binding:"required"`
	Description string  `json:"description"`
	IsPermanent bool    `json:"isPermanent"`
	Location    string  `json:"location" binding:"required"`
	Latitude    float64 `json:"latitude" binding:"required"`
	Longitude   float64 `json:"longitude" binding:"required"`
}

type ColocationUpdateRequest struct {
	Name        string  `json:"name"`
	Description string  `json:"description"`
	IsPermanent bool    `json:"isPermanent"`
	Location    string  `json:"location"`
	Latitude    float64 `json:"latitude"`
	Longitude   float64 `json:"longitude"`
}
