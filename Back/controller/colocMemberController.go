package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

type ColocMemberController struct {
	colocService service.ColocMemberService
}

// CreateColocMember allows to create a new colocation member
// @Summary Create a new colocation member
// @Description Create a new colocation member
// @Tags colocMembers
// @Accept json
// @Produce json
// @Param colocMember body dto.ColocMemberCreateRequest true "Colocation member object"
// @Success 201 {object} dto.ColocMemberCreateRequest
// @Failure 400 {object} error
// @Router /coloc/members [post]
// @Security Bearer
func (ctl *ColocMemberController) CreateColocMember(c *gin.Context) {
	var req dto.ColocMemberCreateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	colocMember := model.ColocMember{
		UserID:       req.UserID,
		ColocationID: req.ColocationID,
		Score:        0,
	}

	if err := ctl.colocService.CreateColocMember(&colocMember); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"Message": "colocation member created successfully",
		"result":  colocMember,
	})
}

// GetColocMemberById fetches a colocation member by its ID
// @Summary Get a colocation member by ID
// @Description Get a colocation member by ID
// @Tags colocMembers
// @Accept json
// @Produce json
// @Param id path int true "Colocation member ID"
// @Success 200 {object} model.ColocMember
// @Failure 404 {object} error
// @Router /coloc/members/{id} [get]
// @Security Bearer
func (ctl *ColocMemberController) GetColocMemberById(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
	}

	colocMember, err := ctl.colocService.GetColocMemberById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}
	// verify that the user is a member of the colocation
	userIdFromToken, exists := c.Get("userID")
	if !exists && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	if colocMember.UserID != userIdFromToken && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return

	}
	c.JSON(http.StatusOK, gin.H{
		"result": colocMember,
	})
}

// GetAllColocMembers fetches all colocation members from the database
// @Summary Get all colocation members
// @Description Get all colocation members
// @Tags colocMembers
// @Accept json
// @Produce json
// @Success 200 {array} model.ColocMember
// @Failure 400 {object} error
// @Router /coloc/members/ [get]
// @Security Bearer
func (ctl *ColocMemberController) GetAllColocMembers(c *gin.Context) {
	if !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}
	colocMembers, err := ctl.colocService.GetAllColocMembers()
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	if !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"colocMembers": colocMembers,
	})
}

// GetAllColocMembersByColoc fetches all colocation members from the database
// @Summary Get all colocation members by colocation
// @Description Get all colocation members by colocation
// @Tags colocMembers
// @Accept json
// @Produce json
// @Param colocId path int true "Colocation ID"
// @Success 200 {array} model.ColocMember
// @Failure 400 {object} error
// @Router/coloc/members/colocation/{colocId} [get]
// @Security Bearer
func (ctl *ColocMemberController) GetAllColocMembersByColoc(c *gin.Context) {

	// verify that the user is allowed to access this resource
	userIdFromToken, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource "})
		return
	}

	// get the coloc from the request and verify that the user is allowed to access this resource

	colocId, err := strconv.Atoi(c.Params.ByName("colocId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}
	var colocService = service.NewColocationService(ctl.colocService.GetDB())
	coloc, err := colocService.GetColocationById(colocId)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	// check if the user is allowed to access this resource
	if coloc.UserID != userIdFromToken && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	colocMembers, err := ctl.colocService.GetAllColocMembersByColoc(colocId)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"colocMembers": colocMembers,
	})
}

// UpdateColocMemberScore allows to update the score of a colocation member
// @Summary Update the score of a colocation member
// @Description Update the score of a colocation member
// @Tags colocMembers
// @Accept json
// @Produce json
// @Param id path int true "Colocation member ID"
// @Param score body dto.ColocMemberScoreUpdateRequest true "Score object"
// @Success 200 {object} dto.ColocMemberScoreUpdateRequest
// @Failure 400 {object} error
// @Router /coloc/members/{id}/score [put]
// @Security Bearer
func (ctl *ColocMemberController) UpdateColocMemberScore(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	var req dto.ColocMemberScoreUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	if err := ctl.colocService.UpdateColocMemberScore(id, req.Score); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "colocation member score updated successfully",
	})
}

// DeleteColocMember allows to delete a colocation member
// @Summary Delete a colocation member
// @Description Delete a colocation member
// @Tags colocMembers
// @Accept json
// @Produce json
// @Param id path int true "Colocation member ID"
// @Success 200 {object} string
// @Failure 400 {object} error
// @Router /coloc/members/{id} [delete]
// @Security Bearer
func (ctl *ColocMemberController) DeleteColocMember(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))

	colocMember, err := ctl.colocService.GetColocMemberById(id)

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	var colocService = service.NewColocationService(ctl.colocService.GetDB())
	coloc, err := colocService.GetColocationById(int(colocMember.ColocationID))
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return

	}

	var userIdFromToken = c.MustGet("userID").(uint)

	if coloc.UserID != userIdFromToken && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	if err := ctl.colocService.DeleteColocMember(id); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "colocation member deleted successfully",
	})

}

func NewColocMemberController(colocMemberService service.ColocMemberService) *ColocMemberController {
	return &ColocMemberController{colocService: colocMemberService}
}
