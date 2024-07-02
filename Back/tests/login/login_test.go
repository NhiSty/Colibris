package login

import (
	"Colibris/dto"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http"
	"testing"
)

var baseURL = "http://localhost:8080/api/v1"

func TestLoginSuccess(t *testing.T) {
	payload := dto.UserLoginRequest{
		Email:    "test@gmail.com",
		Password: "test123!",
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/auth/login", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)

	var response map[string]interface{}
	err = json.NewDecoder(resp.Body).Decode(&response)
	if err != nil {
		return
	}
	assert.NotNil(t, response["token"])
}

func TestLoginFailure(t *testing.T) {
	payload := dto.UserLoginRequest{
		Email:    "invaliduser@example.com",
		Password: "invalidpassword",
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/auth/login", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusUnauthorized, resp.StatusCode)

	var response map[string]interface{}
	err = json.NewDecoder(resp.Body).Decode(&response)
	if err != nil {
		return
	}
	assert.Equal(t, "invalid credentials", response["error"])
}
