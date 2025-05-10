package common

import (
	"encoding/json"
	"fmt"
	"log"
	"time"

	"github.com/go-viper/mapstructure/v2"
)

// Packet represents a websocket message with a type and data payload
type Packet struct {
	Type    string      `json:"type"`
	Time    time.Time   `json:"time"`
	Payload interface{} `json:"payload"`
}

type QueueUpdatePayload struct {
	ISRC  string `mapstructure:"isrc"`
	Index int    `mapstructure:"index"`
}

func (p *Packet) UnmarshalJSON(data []byte) error {
	tempPacket := struct {
		Type    string      `json:"type"`
		Time    time.Time   `json:"time"`
		Payload interface{} `json:"payload"`
	}{}
	json.Unmarshal(data, &tempPacket)

	switch tempPacket.Type {
	case "get_song_data_by_isrc":
		isrc, ok := tempPacket.Payload.(string)
		if !ok {
			return fmt.Errorf("invalid payload")
		}
		p.Payload = isrc
	case "queue_update":
		queueUpdatePayload := &QueueUpdatePayload{}
		err := mapstructure.Decode(tempPacket.Payload, queueUpdatePayload)
		if err != nil {
			return err
		}

		p.Payload = queueUpdatePayload
	}

	p.Type = tempPacket.Type
	p.Time = tempPacket.Time

	log.Println(p)
	log.Println(tempPacket)
	return nil
}
