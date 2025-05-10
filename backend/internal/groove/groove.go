package groove

import (
	"encoding/json"
	"slices"
	"time"
	"vibe/internal/common"
	"vibe/internal/models"

	"github.com/olahol/melody"
)

type Groove struct {
	*melody.Melody
	connectedDevices []*melody.Session // Limit of 10 devices? maybe more... idk but then it should be without individual sessions?
	queue            []*models.Song
	playing          bool
	nextSongStart    time.Time
	maxLatency       time.Duration
}

func (g *Groove) addSongToQueue(isrc string, index int) error {
	song, err := models.FindSongByISRC(isrc)
	if err != nil {
		return err
	}

	slices.Insert(g.queue, index, song)

	bytes, err := json.Marshal(&common.Packet{
		Type:    "queue_update",
		Payload: g.queue,
		Time:    time.Now(),
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
