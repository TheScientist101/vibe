package groove

import (
	"encoding/json"
	"log"
	"time"
	"vibe/internal/common"
	"vibe/internal/models"

	"github.com/olahol/melody"
)

type GrooveRouter struct {
	melody  *melody.Melody
	grooves map[string]*Groove
}

func NewGroove(m *melody.Melody) *GrooveRouter {
	return &GrooveRouter{
		melody:  m,
		grooves: make(map[string]*Groove),
	}
}

func (m *GrooveRouter) HandleMessage(s *melody.Session, msg []byte) {
	var packet common.Packet
	if err := json.Unmarshal(msg, &packet); err != nil {
		errorMsg, _ := json.Marshal(common.Packet{
			Type:    "error",
			Payload: "Invalid message format",
		})
		s.Write(errorMsg)
		return
	}

	switch packet.Type {
	case "get_song_data_by_isrc":
		song, err := models.FindSongByISRC(packet.Payload.(string))
		if err != nil {
			errorMsg, _ := json.Marshal(common.Packet{
				Type:    "error",
				Time:    time.Now(),
				Payload: "Invalid ISRC",
			})
			s.Write(errorMsg)
			return
		}

		response := &common.Packet{
			Type:    "song_data",
			Time:    time.Now(),
			Payload: song,
		}

		jsonResponse, err := json.Marshal(response)
		if err != nil {
			errorMsg, _ := json.Marshal(common.Packet{
				Type:    "error",
				Time:    time.Now(),
				Payload: "Invalid ISRC",
			})
			s.Write(errorMsg)
			return
		}

		s.Write(jsonResponse)
	case "add_song":
		// TODO: Figure out how to assign sessions and things

	default:
		log.Println(packet)
	}
}
