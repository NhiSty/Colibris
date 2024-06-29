package route

import (
	"Colibris/controller"
	"Colibris/middleware"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func FeatureFlagRoutes(router *gin.RouterGroup, db *gorm.DB) {

	featureFlagService := service.NewFeatureFlagService(db)
	featureFlagController := controller.NewFeatureFlagController(*featureFlagService)
	AuthMiddleware := middleware.AuthMiddleware

	featureFlagRoutes := router.Group("/backend/fp")
	{
		featureFlagRoutes.GET("", featureFlagController.GetFeatureFlags)
		featureFlagRoutes.POST("", AuthMiddleware(), featureFlagController.CreateFeatureFlag)
		featureFlagRoutes.GET("/:id", AuthMiddleware(), featureFlagController.GetFeatureFlagByID)
		featureFlagRoutes.PUT("/:id", AuthMiddleware(), featureFlagController.UpdateFeatureFlag)
		featureFlagRoutes.DELETE("/:id", AuthMiddleware(), featureFlagController.DeleteFeatureFlag)
	}
}
