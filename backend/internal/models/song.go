package models

import (
	"encoding/xml"
	"net/http"
	"time"
)

type Song struct {
	Name     string        `json:"name"`
	Artist   string        `json:"artist"`
	Duration time.Duration `json:"duration"`
	ISRC     string        `json:"isrc"`
}

type metadata struct {
	XMLName xml.Name `xml:"metadata"`
	ISRC    struct {
		ID        string `xml:"id,attr"`
		Recording struct {
			Title    string `xml:"title"`
			Length   int64  `xml:"length"`
			Relation struct {
				Artist struct {
					Name string `xml:"name"`
				} `xml:"artist"`
			} `xml:"relation-list>relation"`
		} `xml:"recording-list>recording"`
	} `xml:"isrc"`
}

func FindSongByISRC(isrc string) (*Song, error) {
	response, err := http.Get("https://musicbrainz.org/ws/2/isrc/" + isrc + "?inc=artist-rels")
	if err != nil {
		return nil, err
	}

	packed := &metadata{}
	err = xml.NewDecoder(response.Body).Decode(packed)
	if err != nil {
		return nil, err
	}

	return &Song{
		Name:     packed.ISRC.Recording.Title,
		Artist:   packed.ISRC.Recording.Relation.Artist.Name,
		Duration: time.Duration(packed.ISRC.Recording.Length) * time.Millisecond,
		ISRC:     isrc,
	}, nil
}