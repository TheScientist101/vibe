package models

import (
	"time"
)

type QueueEntry struct {
	Song
	time.Time
}

type Queue []QueueEntry
