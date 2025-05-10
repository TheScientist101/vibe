package api

import (
	"github.com/gin-gonic/gin"
	"github.com/olahol/melody"
	"vibe/internal/groove"
)

type Server struct {
	Router   *gin.Engine
	Melody   *melody.Melody
	QueueMgr *groove.GrooveRouter
}

func NewServer() *Server {
	router := gin.Default()
	m := melody.New()

	queueMgr := groove.NewGroove(m)

	server := &Server{
		Router:   router,
		Melody:   m,
		QueueMgr: queueMgr,
	}

	server.registerRoutes()

	return server
}

func (s *Server) registerRoutes() {
	s.Router.Use(gin.Logger())
	s.Router.Use(gin.Recovery())

	s.Router.GET("/ws", func(ctx *gin.Context) {
		s.Melody.HandleRequest(ctx.Writer, ctx.Request)
	})

	s.Melody.HandleMessage(func(s *melody.Session, msg []byte) {

	})
}
