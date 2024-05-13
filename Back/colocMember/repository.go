package colocMembers

import "gorm.io/gorm"

type ColocMemberRepository interface {
	CreateColocMember(colocMember *ColocMember) error
	GetColocMemberById(id int) (*ColocMember, error)
	GetAllColocMembers() ([]ColocMember, error)
	UpdateColocMemberScore(id int, newScore float32) error
}

type colocMemberRepository struct {
	db *gorm.DB
}

func (r *colocMemberRepository) CreateColocMember(colocMember *ColocMember) error {
	return r.db.Create(colocMember).Error
}

func (r *colocMemberRepository) GetColocMemberById(id int) (*ColocMember, error) {
	var colocMember ColocMember
	result := r.db.Where("id = ?", id).First(&colocMember)
	return &colocMember, result.Error
}

func (r *colocMemberRepository) GetAllColocMembers() ([]ColocMember, error) {
	var colocMembers []ColocMember
	result := r.db.Find(&colocMembers)
	return colocMembers, result.Error
}

func NewColocMemberRepository(db *gorm.DB) ColocMemberRepository {
	return &colocMemberRepository{db: db}
}

func (r *colocMemberRepository) UpdateColocMemberScore(id int, newScore float32) error {
	var colocMember ColocMember
	result := r.db.First(&colocMember, id)
	if result.Error != nil {
		return result.Error
	}
	colocMember.Score = newScore
	return r.db.Save(&colocMember).Error
}
