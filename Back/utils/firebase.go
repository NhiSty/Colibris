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

func NewFirebaseClient() (*FirebaseClient, error) {
	serviceAccountKey := os.Getenv("GOOGLE_APPLICATION_CREDENTIALS_CONTENTS")
	if serviceAccountKey == "" {
		return nil, fmt.Errorf("environment variable GOOGLE_APPLICATION_CREDENTIALS_CONTENTS is not set")
	}

	// Write the service account key to a temporary file
	tmpFile, err := os.CreateTemp("", "serviceAccountKey-*.json")
	if err != nil {
		return nil, fmt.Errorf("error creating temporary file: %v", err)
	}
	defer os.Remove(tmpFile.Name()) // Clean up the file afterwards

	if _, err := tmpFile.Write([]byte(serviceAccountKey)); err != nil {
		return nil, fmt.Errorf("error writing to temporary file: %v", err)
	}
	if err := tmpFile.Close(); err != nil {
		return nil, fmt.Errorf("error closing temporary file: %v", err)
	}

	opt := option.WithCredentialsFile(tmpFile.Name())
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

func (f *FirebaseClient) SubscribeToTopic(token string, id int) error {
	if f.client == nil {
		return fmt.Errorf("Firebase client is not initialized")
	}
	topic := fmt.Sprintf("room_colocation_%d", id)

	response, err := f.client.SubscribeToTopic(context.Background(), []string{token}, topic)
	if err != nil {
		return fmt.Errorf("error subscribing to topic: %v", err)
	}

	log.Printf("Successfully subscribed to topic: %s\n", response)
	return nil
}

func (f *FirebaseClient) UnsubscribeFromTopic(token string, id int) error {
	if f.client == nil {
		return fmt.Errorf("Firebase client is not initialized")
	}

	topic := fmt.Sprintf("room_colocation_%d", id)

	response, err := f.client.UnsubscribeFromTopic(context.Background(), []string{token}, topic)
	if err != nil {
		return fmt.Errorf("error unsubscribing from topic: %v", err)
	}

	log.Printf("Successfully unsubscribed from topic: %s\n", response)
	return nil
}
