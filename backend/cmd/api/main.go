package main

import (
	"log"
	"vibe/internal/api"
)

func main() {
	server := api.NewServer()

	log.Println("Starting server on :8080")
	server.Router.Run(":8080")
}
