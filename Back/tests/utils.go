package tests

import (
	"Colibris/dto"
	"bytes"
	"encoding/json"
	"net/http"
)

var baseURL = "http://golang:8080/api/v1"

func LogAsUser() string {
	token := login("test@gmail.com", "test123!")
	return token
}

func LogAsUser2() string {
	token := login("test2@gmail.com", "test123!")
	return token
}

func LogAsAdmin() string {
	token := login("admin@admin.com", "test123!")
	return token
}

func login(email string, password string) string {
	payload := dto.UserLoginRequest{
		Email:    email,
		Password: password,
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/auth/login", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return ""
	}

	var response map[string]interface{}
	err = json.NewDecoder(resp.Body).Decode(&response)
	if err != nil {
		return ""
	}

	return response["token"].(string)

}
