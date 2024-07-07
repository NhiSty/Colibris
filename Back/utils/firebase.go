package utils

import (
	"context"
	"firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"fmt"
	"google.golang.org/api/option"
	"log"
	"os"
)

// FirebaseClient structure
type FirebaseClient struct {
	client *messaging.Client
}

// NewFirebaseClient initializes and returns a FirebaseClient
func NewFirebaseClient() (*FirebaseClient, error) {
	serviceAccountKeyFilePath := "./utils/serviceAccountKey.json"

	if _, err := os.Stat(serviceAccountKeyFilePath); os.IsNotExist(err) {
		return nil, fmt.Errorf("service account key file does not exist at path: %s", serviceAccountKeyFilePath)
	}

	opt := option.WithCredentialsFile(serviceAccountKeyFilePath)
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		return nil, fmt.Errorf("error initializing app: %v", err)
	}

	client, err := app.Messaging(context.Background())
	if err != nil {
		return nil, fmt.Errorf("error getting Messaging client: %v", err)
	}

	if client == nil {
		return nil, fmt.Errorf("Messaging client is nil")
	}

	return &FirebaseClient{client: client}, nil
}

func (f *FirebaseClient) SendNotification(title, body, senderName, colocationID, topic string) error {
	if f.client == nil {
		return fmt.Errorf("Firebase client is not initialized")
	}

	message := &messaging.Message{
		Notification: &messaging.Notification{
			Title: title,
			Body:  "From: " + senderName + "\n" + body,
		},
		Topic: topic,
		Data: map[string]string{
			"colocationID": colocationID,
		},
	}

	response, err := f.client.Send(context.Background(), message)
	if err != nil {
		return fmt.Errorf("error sending message: %v", err)
	}

	log.Printf("Successfully sent message: %s\n", response)
	return nil
}
