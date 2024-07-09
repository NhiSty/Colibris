package dto

type UpdateUserDTO struct {
	Password  string `json:"password" validate:"omitempty,min=8"`
	Email     string `json:"email" validate:"omitempty,email"`
	FirstName string `json:"firstname" validate:"omitempty"`
	LastName  string `json:"lastname" validate:"omitempty"`
}

type UserInColoc struct {
	ID            uint   `json:"ID"`
	FirstName     string `json:"Firstname"`
	LastName      string `json:"Lastname"`
	Email         string `json:"Email"`
	Score         int    `json:"Score"`
	ColocMemberID uint   `json:"ColocMemberID"`
}
