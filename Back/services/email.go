package services

import (
	"github.com/joho/godotenv"
	"github.com/mailjet/mailjet-apiv3-go/v4"
	"log"
	"os"
)

type MailjetClient struct {
	Client *mailjet.Client
}

func initMailjetClient() (*MailjetClient, error) {
	err := godotenv.Load()
	if err != nil {
		return nil, err
	}
	publicKey := os.Getenv("MJ_APIKEY_PUBLIC")
	privateKey := os.Getenv("MJ_APIKEY_PRIVATE")
	client := mailjet.NewMailjetClient(publicKey, privateKey)
	return &MailjetClient{Client: client}, nil
}

func SendResetPasswordEmail(toEmail, toName, token string) (error, error) {
	mailjetClient, err := initMailjetClient()
	if err != nil {
		log.Println("Failed to initialize Mailjet client:", err)
		return err, nil
	}

	data := map[string]interface{}{
		"template_id":       4965682,
		"username":          toName,
		"name":              toName,
		"email":             toEmail,
		"confirmation_link": token,
	}
	messagesInfo := []mailjet.InfoMessagesV31{
		{
			TemplateID: 4965682,

			From: &mailjet.RecipientV31{
				Email: "oussama.1941@gmail.com",
				Name:  "Mailjet Pilot",
			},
			To: &mailjet.RecipientsV31{
				mailjet.RecipientV31{
					Email: toEmail,
					Name:  toName,
				},
			},
			Variables:        data,
			TemplateLanguage: true,
			Subject:          "Password Reset Request",
		},
	}
	messages := mailjet.MessagesV31{Info: messagesInfo}
	res, err := mailjetClient.Client.SendMailV31(&messages)
	if err != nil {
		log.Println("Failed to send email:", err)
		return err, nil
	}
	log.Printf("Email sent successfully: %+v\n", res)
	return nil, nil
}
