package main

import (
	"log"
	"vibe/models"
)

func main() {
	//	Test find song by ISRC
	song, err := models.FindSongByISRC("USMC60400032")
	if err != nil {
		log.Fatal(err)
	}
	log.Println(song)
}
