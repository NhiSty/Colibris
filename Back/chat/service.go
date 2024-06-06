package chat

import (
	"encoding/json"
	"github.com/gorilla/websocket"
	"log"
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

func (s *ChatService) BroadcastMessage(colocationID string, message []byte, userID int, senderName string) {
	s.clientsMu.Lock()
	defer s.clientsMu.Unlock()

	// Construire le message avec les informations nécessaires
	msg := Message{
		Content:      string(message),
		SenderID:     userID,
		SenderName:   senderName,
		ColocationID: colocationID,
	}

	// Enregistrer le message dans la base de données
	savedMsg, err := s.Repo.SaveMessage(msg)
	if err != nil {
		log.Printf("Erreur lors de l'enregistrement du message : %v", err)
		return
	}

	// Convertir le message enregistré en JSON pour l'envoi
	messageJSON, err := json.Marshal(savedMsg)
	if err != nil {
		log.Printf("Erreur lors de la conversion du message en JSON : %v", err)
		return
	}

	var activeClients []*Client
	for _, client := range s.clients[colocationID] {
		err := client.Conn.WriteMessage(websocket.TextMessage, messageJSON)
		if err != nil {
			log.Printf("Erreur lors de l'envoi du message au client : %v", err)
			client.Conn.Close()
		} else {
			activeClients = append(activeClients, client)
		}
	}
	s.clients[colocationID] = activeClients
}

func (s *ChatService) GetMessages(colocationID string) ([]Message, error) {
	return s.Repo.GetMessages(colocationID)
}
