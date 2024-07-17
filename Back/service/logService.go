package service

import (
	"Colibris/model"
	"gorm.io/gorm"
)

type LogService struct {
	db *gorm.DB
}

func NewLogService(db *gorm.DB) *LogService {
	return &LogService{db: db}
}

func (l *LogService) CreateLog(log *model.Log) error {
	return l.db.Create(log).Error
}

func (l *LogService) GetLogs() ([]model.Log, error) {
	var logs []model.Log
	err := l.db.Order("created_at desc").Limit(500).Find(&logs).Error
	return logs, err
}
