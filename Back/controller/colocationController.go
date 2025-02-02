package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"Colibris/utils"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"strconv"
)

type ColocationController struct {
	colocService service.ColocationService
}

func NewColocationController(colocService service.ColocationService) *ColocationController {
	return &ColocationController{colocService: colocService}
}

// CreateColocation allows to create a new colocation
// @Summary Create a new colocation
// @Description Create a new colocation
// @Tags colocations
// @Accept json
// @Produce json
// @Param colocation body dto.ColocationCreateRequest true "Colocation object"
// @Success 201 {object} dto.ColocationCreateRequest
// @Failure 400 {object} error
// @Router /colocations [post]
// @Security Bearer
func (ctl *ColocationController) CreateColocation(c *gin.Context) {
	var req dto.ColocationCreateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	colocation := model.Colocation{
		Name:        req.Name,
		UserID:      req.UserId,
		Description: req.Description,
		IsPermanent: req.IsPermanent,
		Latitude:    req.Latitude,
		Longitude:   req.Longitude,
		Location:    req.Location,
	}

	if err := ctl.colocService.CreateColocation(&colocation); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	fcmToken, exists := c.Get("fcmToken")
	if !exists {
		c.JSON(http.StatusBadRequest, gin.H{"error": "FCM token not provided"})
		return
	}

	firebaseClient, err := utils.NewFirebaseClient()
	if err != nil {
		log.Printf("error initializing Firebase client: %v\n", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to initialize Firebase client"})
		return
	}

	err = firebaseClient.SubscribeToTopic(fcmToken.(string), int(colocation.ID))
	if err != nil {
		log.Printf("error subscribing to topic: %v\n", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to subscribe to topic"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"Message": "colocation created successfully",
		"result":  colocation,
	})
}

// GetColocationById fetches a colocation by its ID
// @Summary Get a colocation by ID
// @Description Get a colocation by ID
// @Tags colocations
// @Accept json
// @Produce json
// @Param id path int true "Colocation ID"
// @Success 200 {object} model.Colocation
// @Failure 400 {object} error
// @Router /colocations/{id} [get]
// @Security Bearer
func (ctl *ColocationController) GetColocationById(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	coloc, err := ctl.colocService.GetColocationById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"result": coloc,
	})
}

// GetAllColocations fetches all colocations from the database with pagination
// @Summary Get all colocations
// @Description Get all colocations
// @Tags colocations
// @Accept json
// @Produce json
// @Success 200 {array} model.Colocation
// @Failure 400 {object} error
// @Router /colocations [get]
// @Security Bearer
func (ctl *ColocationController) GetAllColocations(c *gin.Context) {
	pageParam := c.DefaultQuery("page", "")
	pageSizeParam := c.DefaultQuery("pageSize", "")

	if pageParam == "" && pageSizeParam == "" {
		colocations, total, err := ctl.colocService.GetAllColocations(0, 0)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"total": total, "colocations": colocations})
		return
	}

	page, err := strconv.Atoi(pageParam)
	if err != nil || page < 1 {
		page = 1
	}

	pageSize, err := strconv.Atoi(pageSizeParam)
	if err != nil || pageSize < 1 {
		pageSize = 5
	}

	colocations, total, err := ctl.colocService.GetAllColocations(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"total":       total,
		"colocations": colocations,
	})
}

// GetAllUserColocations fetches all user's colocations from the database
// @Summary Get all user's colocations
// @Description Get all user's colocations
// @Tags colocations
// @Accept json
// @Produce json
// @Success 200 {array} model.Colocation
// @Param id path int true "User ID"
// @Failure 400 {object} error
// @Router /colocations/user/{id} [get]
// @Security Bearer
func (ctl *ColocationController) GetAllUserColocations(c *gin.Context) {
	userId, err := strconv.Atoi(c.Params.ByName("id"))

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	userIDFromToken, exists := c.Get("userID")
	if !exists || userIDFromToken.(uint) != uint(userId) && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	colocations, err := ctl.colocService.GetAllUserColocations(userId)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"colocations": colocations,
	})
}

// UpdateColocation updates a colocation by its ID
// @Summary Update a colocation by ID
// @Description Update a colocation by ID
// @Tags colocations
// @Accept json
// @Produce json
// @Param id path int true "Colocation ID"
// @Param colocationUpdates body dto.ColocationUpdateRequest true "Colocation object"
// @Success 200 {object} dto.ColocationUpdateRequest
// @Failure 400 {object} error
// @Router /colocations/{id} [patch]
// @Security Bearer
func (ctl *ColocationController) UpdateColocation(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid colocation ID"})
		return
	}

	var req dto.ColocationUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}
	_, err = ctl.colocService.GetColocationById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	// verify if the user is the owner of the colocation
	userIDFromToken, exists := c.Get("userID")
	if !exists && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to update this resource here"})
		return
	}

	coloc, err := ctl.colocService.GetColocationById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	if coloc.UserID != userIDFromToken.(uint) && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to update this resource"})
		return
	}

	colocUpdates := make(map[string]interface{})
	if req.Name != "" {
		colocUpdates["name"] = req.Name
	}
	if req.Description != "" {
		colocUpdates["description"] = req.Description
	}

	if req.IsPermanent == true || req.IsPermanent == false {
		colocUpdates["is_permanent"] = req.IsPermanent
	}

	if _, err := ctl.colocService.UpdateColocation(id, colocUpdates); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "colocation updated successfully",
	})
}

func (ctl *ColocationController) DeleteColocation(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid colocation ID"})
		return
	}

	// verify if the user is the owner of the colocation
	userIDFromToken, exists := c.Get("userID")
	if !exists && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to delete this resource here"})
		return
	}

	// retrieve the colocation
	coloc, err := ctl.colocService.GetColocationById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	if coloc.UserID != userIDFromToken.(uint) && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to delete this resource"})
		return
	}

	if err := ctl.colocService.DeleteColocation(id); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusNoContent, gin.H{
		"Message": "colocation deleted successfully",
	})
}

func (ctl *ColocationController) SearchColocations(c *gin.Context) {
	query := c.DefaultQuery("query", "")

	colocations, err := ctl.colocService.SearchColocations(query)
	if !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, colocations)
}
