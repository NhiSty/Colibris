package logs

import (
	"gorm.io/gorm"
)

type LogRepository struct {
	DB *gorm.DB
}

func NewLogRepository(db *gorm.DB) *LogRepository {
	return &LogRepository{DB: db}
}

func (repo *LogRepository) CreateLog(log *Log) error {
	return repo.DB.Create(log).Error
}

func (repo *LogRepository) GetLogs() ([]Log, error) {
	var logs []Log
	err := repo.DB.Order("created_at desc").Find(&logs).Error
	return logs, err
}
