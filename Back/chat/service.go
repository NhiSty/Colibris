package chat

import (
	"github.com/gorilla/websocket"
	"sync"
)

type ChatService struct {
	Repo      ChatRepository
	clients   map[string][]*Client
	clientsMu sync.Mutex
}

func NewChatService(repo ChatRepository) *ChatService {
	return &ChatService{
		Repo:    repo,
		clients: make(map[string][]*Client),
	}
}

func (s *ChatService) RegisterClient(client *Client) {
	s.clientsMu.Lock()
	defer s.clientsMu.Unlock()

	s.clients[client.ColocationID] = append(s.clients[client.ColocationID], client)
}

func (s *ChatService) BroadcastMessage(colocationID string, message []byte, userID int) {
	s.clientsMu.Lock()
	defer s.clientsMu.Unlock()

	msg := Message{
		Content:      string(message),
		SenderID:     userID,
		ColocationID: colocationID,
	}

	s.Repo.SaveMessage(msg)

	for _, client := range s.clients[colocationID] {
		client.Conn.WriteMessage(websocket.TextMessage, message)
	}
}

func (s *ChatService) GetMessages(colocationID string) ([]Message, error) {
	return s.Repo.GetMessages(colocationID)
}
