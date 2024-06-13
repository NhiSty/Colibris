package interfaces

import (
	"Colibris/models"
)

// ColocMemberRepository defines the methods needed from the coloc member repository
type ColocMemberRepository interface {
	CreateColocMember(colocMember *models.ColocMember) error
	GetColocMemberById(id int) (*models.ColocMember, error)
	GetAllColocMembers() ([]models.ColocMember, error)
	UpdateColocMemberScore(id int, newScore float32) error
	GetAllColocMembersByColoc(colocationId int) ([]models.ColocMember, error)
	GetColocationById(id int) (*models.Colocation, error)
	DeleteColocMember(id int) error
}

type ColocationRepository interface {
	GetColocationById(id int) (*models.Colocation, error)
	CreateColocation(colocation *models.Colocation) error
	GetAllUserColocations(userId int) ([]models.Colocation, error)
	UpdateColocation(id int, colocationUpdates map[string]interface{}) (*models.Colocation, error)
	DeleteColocation(id int) error
}
