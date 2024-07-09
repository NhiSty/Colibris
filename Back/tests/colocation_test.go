package tests

import (
	"Colibris/dto"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http"
	"testing"
)

func TestCreateColocationSuccess(t *testing.T) {

	token := LogAsUser()
	payload := dto.ColocationCreateRequest{
		Name:        "Colocation 1",
		Description: "Description of colocation 1",
		Latitude:    48.8566,
		Longitude:   2.3522,
		Location:    "Paris",
		IsPermanent: true,
		UserId:      2,
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/colocations", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusCreated, resp.StatusCode)
}

func TestCreateColocationSuccess2(t *testing.T) {

	token := LogAsUser()
	payload := dto.ColocationCreateRequest{
		Name:        "Colocation 1",
		Description: "Description of colocation 1",
		Latitude:    48.8566,
		Longitude:   2.3522,
		Location:    "Paris",
		IsPermanent: true,
		UserId:      2,
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/colocations", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusCreated, resp.StatusCode)
}

func TestGetColocationSuccess(t *testing.T) {
	token := LogAsUser()
	req, _ := http.NewRequest("GET", baseURL+"/colocations/1", nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestGetCollocationFailure(t *testing.T) {
	token := LogAsUser()
	req, _ := http.NewRequest("GET", baseURL+"/colocations/100", nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)
}

func TestUpdateColocationSuccess(t *testing.T) {

	token := LogAsUser()
	payload := dto.ColocationUpdateRequest{
		Name:        "Colocation 1 updated ",
		Description: "Description of colocation 1 updated",
		IsPermanent: true,
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("PATCH", baseURL+"/colocations/1", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func TestUpdateColocationFailure(t *testing.T) {
	token := LogAsUser()
	payload := dto.ColocationUpdateRequest{
		Name:        "Colocation 1 updated ",
		Description: "Description of colocation 1 updated",
		IsPermanent: true,
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("PATCH", baseURL+"/colocations/100", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)
}

func TestUpdateColocationForbidden(t *testing.T) {
	token := LogAsUser2()
	payload := dto.ColocationUpdateRequest{
		Name:        "Colocation 1 updated ",
		Description: "Description of colocation 1 updated",
		IsPermanent: true,
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("PATCH", baseURL+"/colocations/1", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusForbidden, resp.StatusCode)
}

func TestDeleteColocationSuccess(t *testing.T) {
	token := LogAsUser()
	req, _ := http.NewRequest("DELETE", baseURL+"/colocations/2", nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusNoContent, resp.StatusCode)

}

func TestDeleteColocationFailure(t *testing.T) {
	token := LogAsUser()
	req, _ := http.NewRequest("DELETE", baseURL+"/colocations/100", nil)
	req.Header.Set("Authorization", "Bearer "+token)

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusNotFound, resp.StatusCode)

}
