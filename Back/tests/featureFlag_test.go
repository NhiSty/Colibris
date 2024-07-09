package tests

import (
	"Colibris/dto"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http"
	"testing"
)

func TestFeatureFlagSuccess(t *testing.T) {
	token := LogAsAdmin()
	payload := dto.FeatureFlagCreateRequest{
		Name:  "Feature Flag 1",
		Value: true,
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/backend/fp", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusCreated, resp.StatusCode)
}

func TestGetFeatureFlagSuccess(t *testing.T) {
	token := LogAsAdmin()
	req, _ := http.NewRequest("GET", baseURL+"/backend/fp/1", nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGetFeatureFlagFailure(t *testing.T) {
	token := LogAsAdmin()
	req, _ := http.NewRequest("GET", baseURL+"/backend/fp/100", nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)
}

func TestUpdateFeatureFlagSuccess(t *testing.T) {
	token := LogAsAdmin()
	payload := dto.FeatureFlagUpdateRequest{
		Name:  "Feature Flag 1",
		Value: false,
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("PUT", baseURL+"/backend/fp/1", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestUpdateFeatureFlagFailure(t *testing.T) {
	token := LogAsAdmin()
	payload := dto.FeatureFlagUpdateRequest{
		Name:  "Feature Flag 1",
		Value: false,
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("PUT", baseURL+"/backend/fp/100", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)
}

func TestDeleteFeatureFlagSuccess(t *testing.T) {
	token := LogAsAdmin()
	req, _ := http.NewRequest("DELETE", baseURL+"/backend/fp/1", nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestDeleteFeatureFlagFailure(t *testing.T) {
	token := LogAsAdmin()
	req, _ := http.NewRequest("DELETE", baseURL+"/backend/fp/100", nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)
}

func TestFeatureFlagForbidden(t *testing.T) {
	token := LogAsUser()
	payload := dto.FeatureFlagCreateRequest{
		Name:  "Feature Flag 1",
		Value: true,
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/backend/fp", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusForbidden, resp.StatusCode)
}
