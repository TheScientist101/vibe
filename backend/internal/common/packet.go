package common

import (
	"encoding/json"
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

func (p Packet) UnmarshalJSON(data []byte) error {
	json.Unmarshal(data, &p)

	switch p.Type {
	case "queue_update":
		queueUpdatePayload := &QueueUpdatePayload{}
		err := mapstructure.Decode(p.Payload, queueUpdatePayload)
		if err != nil {
			return err
		}

		p.Payload = queueUpdatePayload
	}

	return nil
}
