package colocMembers

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func ColocMemberRoutes(colocMemberRoutes *gin.RouterGroup, db *gorm.DB) {
	routes := colocMemberRoutes.Group("/coloc-members")
	colocMemberRepo := NewColocMemberRepository(db)
	colocMemberService := NewColocMemberService(colocMemberRepo)
	colocMemberController := NewColocMemberController(colocMemberService)
	{
		routes.POST("", colocMemberController.CreateColocMember)
		routes.GET("/:id", colocMemberController.GetColocMemberById)
		routes.GET("", colocMemberController.GetAllColocMembers)
		routes.PUT("/:id/score", colocMemberController.UpdateColocMemberScore)

	}
}
