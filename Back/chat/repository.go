package chat

import (
	"gorm.io/gorm"
)

type ChatRepository interface {
	SaveMessage(message Message) (*Message, error)
	GetMessages(colocationID string) ([]Message, error)
}

type GormChatRepository struct {
	db *gorm.DB
}

func NewChatRepository(db *gorm.DB) *GormChatRepository {
	return &GormChatRepository{db: db}
}

func (r *GormChatRepository) SaveMessage(message Message) (*Message, error) {
	err := r.db.Create(&message).Error
	return &message, err
}

func (r *GormChatRepository) GetMessages(colocationID string) ([]Message, error) {
	var messages []Message
	if err := r.db.Where("colocation_id = ?", colocationID).Order("created_at ASC").Find(&messages).Error; err != nil {
		return nil, err
	}
	return messages, nil
}
