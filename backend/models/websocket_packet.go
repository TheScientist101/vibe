package models

type WebsocketPacket struct {
	Type string      `json:"type"`
	Data interface{} `json:"data"`
}
