package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

type FeatureFlagController struct {
	featureFlagService service.FeatureFlagService
}

// CreateFeatureFlag allows to create a new feature flag
// @Summary Create a new feature flag
// @Description Create a new feature flag
// @Tags featureFlags
// @Accept json
// @Produce json
// @Param featureFlag body dto.FeatureFlagCreateRequest true "Feature flag object"
// @Success 201 {object} dto.FeatureFlagCreateRequest
// @Failure 400 {object} error
// @Router /backend/fp [post]
// @Security Bearer
func (c *FeatureFlagController) CreateFeatureFlag(ctx *gin.Context) {

	if !service.IsAdmin(ctx) {
		ctx.JSON(http.StatusUnauthorized, "You are not authorized to create a feature flag")
		return
	}

	var req dto.FeatureFlagCreateRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, err.Error())
		return
	}

	flag := model.FeatureFlag{
		Name:  req.Name,
		Value: req.Value,
	}

	if err := c.featureFlagService.CreateFeatureFlag(&flag); err != nil {
		ctx.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	ctx.JSON(http.StatusCreated, gin.H{
		"Message": "feature flag created successfully",
	})
}

// GetFeatureFlags fetches all feature flags
// @Summary Get all feature flags
// @Description Get all feature flags
// @Tags featureFlags
// @Accept json
// @Produce json
// @Success 200 {object} []model.FeatureFlag
// @Failure 404 {object} error
// @Router /backend/fp [get]
// @Security Bearer
func (c *FeatureFlagController) GetFeatureFlags(ctx *gin.Context) {

	flags, err := c.featureFlagService.GetFeatureFlags()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	ctx.JSON(http.StatusOK, flags)
}

func NewFeatureFlagController(featureFlagService service.FeatureFlagService) *FeatureFlagController {
	return &FeatureFlagController{featureFlagService: featureFlagService}
}

// GetFeatureFlagByID fetches a feature flag by its ID
// @Summary Get a feature flag by ID
// @Description Get a feature flag by ID
// @Tags featureFlags
// @Accept json
// @Produce json
// @Param id path int true "Feature flag ID"
// @Success 200 {object} model.FeatureFlag
// @Failure 404 {object} error
// @Router /backend/fp/{id} [get]
// @Security Bearer
func (c *FeatureFlagController) GetFeatureFlagByID(ctx *gin.Context) {

	if !service.IsAdmin(ctx) {
		ctx.JSON(http.StatusUnauthorized, "You are not authorized to get feature flag")
		return

	}
	id, err := strconv.Atoi(ctx.Params.ByName("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, err.Error())
		return
	}

	flag, err := c.featureFlagService.GetFeatureFlagByID(uint(id))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, err.Error())
		return
	}
	ctx.JSON(http.StatusOK, flag)
}

// UpdateFeatureFlag allows to update a feature flag
// @Summary Update a feature flag
// @Description Update a feature flag
// @Tags featureFlags
// @Accept json
// @Produce json
// @Param id path int true "Feature flag ID"
// @Param featureFlag body dto.FeatureFlagUpdateRequest true "Feature flag object"
// @Success 200 {object} dto.FeatureFlagUpdateRequest
// @Failure 400 {object} error
// @Router /backend/fp/{id} [put]
// @Security Bearer
func (c *FeatureFlagController) UpdateFeatureFlag(ctx *gin.Context) {

	if !service.IsAdmin(ctx) {
		ctx.JSON(http.StatusUnauthorized, "You are not authorized to update feature flag")
		return
	}

	var req dto.FeatureFlagUpdateRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, err.Error())
		return
	}

	id, err := strconv.Atoi(ctx.Params.ByName("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, err.Error())
		return
	}

	flag, err := c.featureFlagService.GetFeatureFlagByID(uint(id))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "record not found"})
		return
	}

	flag.Name = req.Name
	flag.Value = req.Value

	if err := c.featureFlagService.UpdateFeatureFlag(flag); err != nil {
		ctx.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"Message": "feature flag updated successfully",
	})
}

// DeleteFeatureFlag allows to delete a feature flag
// @Summary Delete a feature flag
// @Description Delete a feature flag
// @Tags featureFlags
// @Accept json
// @Produce json
// @Param id path int true "Feature flag ID"
// @Success 200 {object} string
// @Failure 400 {object} error
// @Router /backend/fp/{id} [delete]
// @Security Bearer
func (c *FeatureFlagController) DeleteFeatureFlag(ctx *gin.Context) {
	if !service.IsAdmin(ctx) {
		ctx.JSON(http.StatusUnauthorized, "You are not authorized to delete feature flag")
		return
	}

	id, err := strconv.Atoi(ctx.Params.ByName("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, err.Error())
		return
	}

	flag, err := c.featureFlagService.GetFeatureFlagByID(uint(id))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	if err := c.featureFlagService.DeleteFeatureFlag(flag); err != nil {
		ctx.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"Message": "feature flag deleted successfully",
	})

}
