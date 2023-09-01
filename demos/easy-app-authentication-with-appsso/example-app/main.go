package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
)

func validateEnvironment() error {
	for _, k := range []string{"AUTH_SERVICE_URI"} {
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
	page := `
<html>
<head></head>
<body>
<a href=\"%s\">Click here to log in</a>
</body>
</html>
`
	fmt.Fprintf(w, page, os.Getenv("AUTH_SERVICE_URI"))
}

func RedirectHandler(w http.ResponseWriter, r *http.Request) {
	encodedToken := strings.ReplaceAll(r.Header.Get("Authorization"), "Bearer ", "")
	page := `
<html>
<body>
<div><b>Welcome!</div>
<div><p>You're logged in. Your encoded token is: %s</p></div>
</body>
</html>
`
	fmt.Fprintf(w, page, encodedToken)
}
