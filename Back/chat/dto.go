package chat

type MessageDTO struct {
	Content      string `json:"content"`
	SenderID     int    `json:"sender_id"`
	ColocationID string `json:"colocation_id"`
}
