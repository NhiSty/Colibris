package tests

import (
	"Colibris/dto"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http"
	"testing"
)

func TestCreateColocMemberSuccess(t *testing.T) {
	token := LogAsAdmin()
	payload := dto.ColocMemberCreateRequest{
		ColocationID: 1,
		UserID:       3,
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/coloc/members/", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	_, err := client.Do(req)
	assert.Nil(t, err)
}

func TestGetColocMemberSuccess(t *testing.T) {
	token := LogAsUser()
	req, _ := http.NewRequest("GET", baseURL+"/coloc/members/1", nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGetColocMemberFailure(t *testing.T) {
	token := LogAsUser()
	req, _ := http.NewRequest("GET", baseURL+"/coloc/members/100", nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)
}
