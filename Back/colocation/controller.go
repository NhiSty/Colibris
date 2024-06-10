package colocations

import (
	"Colibris/models"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

type Controller struct {
	colocService ColocationService
}

func (ctl *Controller) CreateColocation(c *gin.Context) {
	var req ColocationCreateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	colocation := models.Colocation{
		Name:        req.Name,
		UserID:      req.UserId,
		Description: req.Description,
		IsPermanent: req.IsPermanent,
		Address:     req.Address,
		City:        req.City,
		ZipCode:     req.ZipCode,
		Country:     req.Country,
	}

	if err := ctl.colocService.createColocation(&colocation); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"Message": "colocation created successfully",
		"result":  colocation,
	})
}

func NewColocController(colocService ColocationService) *Controller {
	return &Controller{colocService: colocService}
}

func (ctl *Controller) GetColocationById(c *gin.Context) {

	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}
	coloc, err := ctl.colocService.getColocationById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"result": coloc,
	})
}

func (ctl *Controller) GetAllUserColocations(c *gin.Context) {
	userId, err := strconv.Atoi(c.Params.ByName("userId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	userIDFromToken, exists := c.Get("userID")
	if !exists || userIDFromToken.(uint) != uint(userId) {
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

func (ctl *Controller) UpdateColocation(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid colocation ID"})
		return
	}

	var req ColocationUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}
	// check if the colocation exists
	_, err = ctl.colocService.getColocationById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	// verify if the user is the owner of the colocation
	userIDFromToken, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to update this resource here"})
		return
	}

	// retrieve the colocation
	coloc, err := ctl.colocService.getColocationById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	if coloc.UserID != userIDFromToken.(uint) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to update this resource"})
		return
	}

	// check if the user is the owner of the colocation
	_, err = ctl.colocService.getColocationById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return

	}
	colocUpdates := make(map[string]interface{})
	if req.Name != "" {
		colocUpdates["name"] = req.Name
	}
	if req.Description != "" {
		colocUpdates["description"] = req.Description
	}

	if _, err := ctl.colocService.UpdateColocation(id, colocUpdates); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "colocation updated successfully",
	})
}

func (ctl *Controller) DeleteColocation(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid colocation ID"})
		return
	}

	// verify if the user is the owner of the colocation
	userIDFromToken, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to delete this resource here"})
		return
	}

	// retrieve the colocation
	coloc, err := ctl.colocService.getColocationById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	if coloc.UserID != userIDFromToken.(uint) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to delete this resource"})
		return
	}

	if err := ctl.colocService.DeleteColocation(id); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "colocation deleted successfully",
	})
}
