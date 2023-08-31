package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func validateEnvironment() error {
	for _, k := range []string{"CLIENT_ID", "CLIENT_SECRET", "ISSUER_URI"} {
		if os.Getenv(k) == "" {
			return fmt.Errorf("Please set: %s", k)
		}
	}
	return nil
}

func main() {
	if err := validateEnvironment(); err != nil {
		log.Fatalf("Something went wrong: %s", err)
		os.Exit(1)
	}
	http.HandleFunc("/", ServeIndexPage)
	http.HandleFunc("/redirect", RedirectHandler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func ServeIndexPage(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "<html><a href=\"%s\">Click here to log in!</a></html>", os.Getenv("ISSUER_URI"))
}

func RedirectHandler(w http.ResponseWriter, r *http.Request) {
	if err := r.ParseForm(); err != nil {
		fmt.Fprintf(os.Stderr, "Couldn't parse query: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}
}
