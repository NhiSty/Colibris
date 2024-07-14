package service

import (
	"Colibris/model"
	"encoding/json"
	"github.com/gorilla/websocket"
	"gorm.io/gorm"
	"log"
	"sync"
)

type ChatService struct {
	db        *gorm.DB
	clients   map[string][]*model.Client
	clientsMu sync.Mutex
}

func NewChatService(db *gorm.DB) *ChatService {
	return &ChatService{
		db:      db,
		clients: make(map[string][]*model.Client),
	}
}

func (c *ChatService) RegisterClient(client *model.Client) {
	c.clientsMu.Lock()
	defer c.clientsMu.Unlock()

	c.clients[client.ColocationID] = append(c.clients[client.ColocationID], client)
}

func (c *ChatService) BroadcastMessage(colocationID string, message []byte, userID int, senderName string) {
	c.clientsMu.Lock()
	defer c.clientsMu.Unlock()

	msg := model.Message{
		Content:      string(message),
		SenderID:     userID,
		SenderName:   senderName,
		ColocationID: colocationID,
	}

	savedMsg, err := c.SaveMessage(msg)
	if err != nil {
		log.Printf("Erreur lors de l'enregistrement du message : %v", err)
		return
	}

	messageJSON, err := json.Marshal(savedMsg)
	if err != nil {
		log.Printf("Erreur lors de la conversion du message en JSON : %v", err)
		return
	}

	var activeClients []*model.Client
	for _, client := range c.clients[colocationID] {
		err := client.Conn.WriteMessage(websocket.TextMessage, messageJSON)
		if err != nil {
			log.Printf("Erreur lors de l'envoi du message au client : %v", err)
			client.Conn.Close()
		} else {
			activeClients = append(activeClients, client)
		}
	}
	c.clients[colocationID] = activeClients
}

func (c *ChatService) BroadcastDeleteMessage(colocationID string, messageID int) {
	c.clientsMu.Lock()
	defer c.clientsMu.Unlock()

	deleteMessage := map[string]interface{}{
		"type":      "delete",
		"messageID": messageID,
	}
	messageJSON, _ := json.Marshal(deleteMessage)

	var activeClients []*model.Client
	for _, client := range c.clients[colocationID] {
		err := client.Conn.WriteMessage(websocket.TextMessage, messageJSON)
		if err != nil {
			log.Printf("Erreur lors de l'envoi du message au client : %v", err)
			client.Conn.Close()
		} else {
			activeClients = append(activeClients, client)
		}
	}
	c.clients[colocationID] = activeClients
}

func (c *ChatService) DeleteMessage(colocationID string, messageID int) error {
	err := c.db.Delete(&model.Message{}, messageID).Error
	if err != nil {
		return err
	}

	c.BroadcastDeleteMessage(colocationID, messageID)
	return nil
}

func (c *ChatService) GetMessages(colocationID string) ([]model.Message, error) {
	var messages []model.Message
	if err := c.db.Where("colocation_id = ?", colocationID).Order("created_at ASC").Find(&messages).Error; err != nil {
		return nil, err
	}
	return messages, nil
}

func (c *ChatService) SaveMessage(message model.Message) (*model.Message, error) {
	err := c.db.Create(&message).Error
	return &message, err
}
