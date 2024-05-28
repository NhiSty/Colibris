package chat

import (
	"github.com/gorilla/websocket"
	"gorm.io/gorm"
)

type Message struct {
	gorm.Model
	Content      string `json:"content"`
	SenderID     int    `json:"sender_id"`
	ColocationID string `json:"colocation_id"`
}

type Client struct {
	Conn         *websocket.Conn
	ColocationID string
}
