package main

import (
	"bytes"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGettingCustomerProfiles(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/api/customer-profiles", nil)
	w := httptest.NewRecorder()
	getCustomerProfiles(w, req)
	resp := w.Result()
	assert.Equal(t, resp.StatusCode, http.StatusOK)
	defer resp.Body.Close()
	got, err := io.ReadAll(resp.Body)
	if err != nil {
		t.Errorf("Couldn't read body: %s", err.Error())
	}
	want, _ := json.Marshal(customerProfiles)
	want = append(want, '\n')
	assert.Equal(t, want, got)
}

func TestAddingNewProfiles(t *testing.T) {
	newProfile := customerProfile{
		FirstName:    "Johnny",
		LastName:     "Programmer",
		EmailAddress: "johnny.programmer@foo.com",
	}
	body, _ := json.Marshal(newProfile)
	req := httptest.NewRequest(http.MethodPost, "/api/customer-profiles",
		bytes.NewReader(body))
	w := httptest.NewRecorder()
	addCustomerProfile(w, req)
	resp := w.Result()
	assert.Equal(t, resp.StatusCode, http.StatusCreated)
	assert.Len(t, customerProfiles, 6)
	assert.Equal(t, customerProfiles[5], newProfile)
}
