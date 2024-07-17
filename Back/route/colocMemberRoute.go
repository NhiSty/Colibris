package route

import (
	"Colibris/controller"
	"Colibris/middleware"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func ColocMemberRoutes(colocMemberRoutes *gin.RouterGroup, db *gorm.DB) {
	routes := colocMemberRoutes.Group("/coloc/members")

	colocMemberService := service.NewColocMemberService(db)
	userService := service.NewUserService(db)
	colocMemberController := controller.NewColocMemberController(colocMemberService, userService)
	AuthMiddleware := middleware.AuthMiddleware

	{
		routes.POST("", AuthMiddleware("ROLE_ADMIN"), colocMemberController.CreateColocMember)
		routes.GET("/:id", AuthMiddleware(), colocMemberController.GetColocMemberById)
		routes.GET("/colocation/:colocId", AuthMiddleware(), colocMemberController.GetAllColocMembersByColoc)
		routes.GET("", AuthMiddleware(), colocMemberController.GetAllColocMembers)
		routes.PUT("/:id/score", AuthMiddleware(), colocMemberController.UpdateColocMemberScore)
		routes.DELETE("/:id", AuthMiddleware(), colocMemberController.DeleteColocMember)
		routes.GET("/search", AuthMiddleware("ROLE_ADMIN"), colocMemberController.SearchColocMembers)
	}
}
