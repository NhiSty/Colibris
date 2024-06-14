package dto

type UpdateUserDTO struct {
	Password  string `json:"password" validate:"omitempty,min=8"`
	Email     string `json:"email" validate:"omitempty,email"`
	FirstName string `json:"firstname" validate:"omitempty"`
	LastName  string `json:"lastname" validate:"omitempty"`
}
