package main

import (
	"log"
	"net/http"
	"vibe/internal/api"
)

func main() {
	server := api.NewServer()

	log.Println("Starting server on :8080")
	if err := http.ListenAndServe(":8080", server.Router); err != nil {
		log.Fatalf("Error starting server: %v", err)
	}
}
