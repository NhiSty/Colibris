package tests

import (
	"Colibris/dto"
	"fmt"

	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http"
	"testing"
)

func TestRegisterSuccess(t *testing.T) {
	payload := dto.UserRegistrationRequest{
		Email:     "test2@gmail.com",
		Password:  "test123!",
		FirstName: "user",
		LastName:  "user",
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/auth/register", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
	}

	assert.Equal(t, http.StatusCreated, resp.StatusCode)
}

func TestRegister2Success(t *testing.T) {
	payload := dto.UserRegistrationRequest{
		Email:     "test3@gmail.com",
		Password:  "test123!",
		FirstName: "user",
		LastName:  "user",
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/auth/register", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
	}

	assert.Equal(t, http.StatusCreated, resp.StatusCode)
}

func TestRegisterFailure(t *testing.T) {
	payload := dto.UserRegistrationRequest{
		Email:     "invaliduserexample.com",
		Password:  "test123!",
		FirstName: "user",
		LastName:  "user",
	}

	jsonPayload, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", baseURL+"/auth/register", bytes.NewBuffer(jsonPayload))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	assert.Nil(t, err)
	assert.Equal(t, http.StatusBadRequest, resp.StatusCode)
}
