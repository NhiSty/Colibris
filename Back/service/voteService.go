package service

import (
	"Colibris/model"
	"gorm.io/gorm"
)

type VoteService struct {
	db *gorm.DB
}

func NewVoteService(db *gorm.DB) VoteService {
	return VoteService{db: db}
}

func (v *VoteService) AddVote(vote *model.Vote) error {
	return v.db.Create(vote).Error
}

func (v *VoteService) GetVoteById(id int) (*model.Vote, error) {
	var vote model.Vote
	result := v.db.Where("id = ?", id).First(&vote)
	return &vote, result.Error
}

func (v *VoteService) GetAllVotes() ([]model.Vote, error) {
	var votes []model.Vote
	result := v.db.Find(&votes)
	return votes, result.Error
}

func (v *VoteService) GetVotesByTaskId(taskId int) ([]model.Vote, error) {
	var votes []model.Vote
	result := v.db.Where("task_id = ?", taskId).Find(&votes)
	return votes, result.Error
}

func (v *VoteService) GetVoteByTaskIdAndUserId(taskId int, userId int) (*model.Vote, error) {
	var vote model.Vote
	result := v.db.Where("task_id = ?", taskId).Where("user_id = ?", userId).First(&vote)
	return &vote, result.Error
}

func (v *VoteService) GetVotesByUserId(userId int) ([]model.Vote, error) {
	var votes []model.Vote
	result := v.db.Where("user_id = ?", userId).Find(&votes)
	return votes, result.Error
}

func (v *VoteService) UpdateVote(id int, voteUpdates map[string]interface{}) (*model.Vote, error) {
	var vote model.Vote

	if err := v.db.Model(&vote).Where("id = ?", id).Updates(voteUpdates).Error; err != nil {
		return nil, err
	}
	if err := v.db.Where("id = ?", id).First(&vote).Error; err != nil {
		return &vote, err
	}

	return &vote, nil
}

func (v *VoteService) DeleteVote(id int) error {
	return v.db.Where("id = ?", id).Delete(&model.Vote{}).Error
}

func (v *VoteService) GetDB() *gorm.DB {
	return v.db
}
