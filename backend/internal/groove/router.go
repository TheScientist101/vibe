package groove

import (
	"encoding/json"
	"vibe/internal/common"

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

func (m *GrooveRouter) handleMessage(s *melody.Session, msg []byte) {
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
	case "add_song":
		// TODO: Figure out how to assign sessions and things

	default:
	}
}
