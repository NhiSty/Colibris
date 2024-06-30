package dto

type FeatureFlagCreateRequest struct {
	Name  string `json:"name" binding:"required"`
	Value bool   `json:"value"`
}

type FeatureFlagUpdateRequest struct {
	Name  string `json:"name"`
	Value bool   `json:"value"`
}
