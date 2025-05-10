package models

import (
	"encoding/json"
	"slices"
	"time"

	"github.com/olahol/melody"
)

type QueueEntry struct {
	Song
}

type Groove struct {
	*melody.Melody
	connectedDevices []*melody.Session // Limit of 10 devices? maybe more... idk but then it should be without individual sessions?
	queue            []*Song
	playing          bool
	nextSongStart    time.Time
	maxLatency       time.Duration
}

func (g *Groove) addSongToQueue(isrc string, index int) error {
	song, err := findSongByISRC(isrc)
	if err != nil {
		return err
	}

	slices.Insert(g.queue, index, song)

	bytes, err := json.Marshal(&WebsocketPacket{
		Type: "queue_update",
		Data: g.queue,
	})
	if err != nil {
		return err
	}

	err = g.Melody.BroadcastMultiple(bytes, g.connectedDevices)
	if err != nil {
		return err
	}

	return nil
}
