package colocMembers

import (
	colocations "Colibris/colocation"
	"Colibris/middlewares"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func Routes(colocMemberRoutes *gin.RouterGroup, db *gorm.DB) {
	routes := colocMemberRoutes.Group("/coloc/members")
	colocationRepo := colocations.NewColocationRepository(db)
	colocMemberRepo := NewColocMemberRepository(db, colocationRepo)
	colocMemberService := NewColocMemberService(colocMemberRepo)
	colocMemberController := NewColocMemberController(colocMemberService)
	AuthMiddleware := middlewares.AuthMiddleware

	{
		routes.POST("", AuthMiddleware(), colocMemberController.CreateColocMember)
		routes.GET("/:id", AuthMiddleware(), colocMemberController.GetColocMemberById)
		routes.GET("/colocation/:colocId", AuthMiddleware(), colocMemberController.GetAllColocMembersByColoc)
		routes.GET("", AuthMiddleware(), colocMemberController.GetAllColocMembers)
		routes.PUT("/:id/score", AuthMiddleware(), colocMemberController.UpdateColocMemberScore)
		routes.DELETE("/:id", AuthMiddleware(), colocMemberController.DeleteColocMember)

	}
}
