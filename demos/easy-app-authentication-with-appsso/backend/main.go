package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
)

type customerProfile struct {
	ID           int    `json:"id"`
	FirstName    string `json:"firstName"`
	LastName     string `json:"lastName"`
	EmailAddress string `json:"email"`
}

var customerProfiles = []customerProfile{
	{ID: 0, FirstName: "Bob", LastName: "Graves", EmailAddress: "bobgraves@foo.com"},
	{ID: 1, FirstName: "Bobby", LastName: "Graves", EmailAddress: "bobgraves@foo.com"},
	{ID: 2, FirstName: "Bobbert", LastName: "Graves", EmailAddress: "bobgraves@foo.com"},
	{ID: 3, FirstName: "Robert", LastName: "Graves", EmailAddress: "bobgraves@foo.com"},
	{ID: 4, FirstName: "Robby", LastName: "Graves", EmailAddress: "bobgraves@foo.com"},
}

func getCustomerProfiles(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(customerProfiles)
}

func addCustomerProfile(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	var profile customerProfile
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, fmt.Sprintf("couldn't read body: %s", err.Error()), http.StatusInternalServerError)
	}
	if err := json.Unmarshal(body, &profile); err != nil {
		http.Error(w, fmt.Sprintf("couldn't read body: %s", err.Error()), http.StatusInternalServerError)
		return
	}
	customerProfiles = append(customerProfiles, profile)
	w.WriteHeader(http.StatusCreated)
}

func routeCustomerProfiles(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodGet:
		getCustomerProfiles(w, r)
	case http.MethodPost:
		addCustomerProfile(w, r)
	default:
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
}

func startServer() {
	http.HandleFunc("/api/customer-profiles/", routeCustomerProfiles)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func main() {
	startServer()
}
