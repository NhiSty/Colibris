package tests

import (
	"Colibris/dto"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http"
	"testing"
)

func TestCreateInvitationSuccess(t *testing.T) {
	token := LogAsUser()
	payload := dto.InvitationCreateRequest{
		ColocationID: 1,
		Email:        "test3@gmail.com",
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/invitations", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)

	assert.Equal(t, http.StatusCreated, resp.StatusCode)
}

func TestCreateInvitationFailure(t *testing.T) {
	token := LogAsUser()
	payload := dto.InvitationCreateRequest{
		ColocationID: 3,
		Email:        "test3@gmail.com",
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/invitations", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)

	assert.Equal(t, http.StatusNotFound, resp.StatusCode)
}
