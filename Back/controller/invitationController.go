package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

type InvitationController struct {
	invService service.InvitationService
}

// CreateInvitation allows to create a new invitation
// @Summary Create a new invitation
// @Description Create a new invitation
// @Tags invitations
// @Accept json
// @Produce json
// @Param invitation body dto.InvitationCreateRequest true "Invitation object"
// @Success 201 {object} dto.InvitationCreateRequest
// @Failure 400 {object} error
// @Router /invitations [post]
// @Security Bearer
func (ctl *InvitationController) CreateInvitation(c *gin.Context) {
	var req dto.InvitationCreateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	var userService = service.NewUserService(ctl.invService.GetDB())
	user, err := userService.GetUserByEmail(req.Email)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}
	userIDFromToken, exists := c.Get("userID")
	if !exists || userIDFromToken.(uint) == user.ID {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to invite yourself"})
		return
	}

	for _, member := range user.Colocations {
		for _, colocation := range member.ColocMembers {
			if colocation.ColocationID == req.ColocationID {
				c.JSON(http.StatusForbidden, gin.H{"error": "User is already a member of the colocation"})
				return
			}
		}

	}

	invitation := model.Invitation{
		UserID:       user.ID,
		ColocationID: req.ColocationID,
		State:        "pending",
		Sender:       userIDFromToken.(uint),
	}

	if err := ctl.invService.CreateInvitation(&invitation); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"Message": "invitation created successfully",
		"result":  invitation,
	})
}

// GetAllUserInvitation fetches all user's invitations from the database
// @Summary Get all invitations
// @Description Get all invitations
// @Tags invitations
// @Accept json
// @Produce json
// @Success 200 {array} model.Invitation
// @Param id path int true "User ID"
// @Failure 400 {object} error
// @Router /invitations/user/{id} [get]
// @Security Bearer
func (ctl *InvitationController) GetAllUserInvitation(c *gin.Context) {

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

	invitations, err := ctl.invService.GetAllUserInvitation(userId)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
	}

	c.JSON(http.StatusOK, gin.H{
		"result": invitations,
	})
}

// UpdateInvitation allows to update an invitation
// @Summary Update an invitation
// @Description Update an invitation
// @Tags invitations
// @Accept json
// @Produce json
// @Param invitation body dto.InvitationUpdateRequest true "Invitation object"
// @Success 200 {object} dto.InvitationUpdateRequest
// @Failure 400 {object} error
// @Router /invitations [patch]
// @Security Bearer
func (ctl *InvitationController) UpdateInvitation(c *gin.Context) {
	var req dto.InvitationUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	if req.State != "accepted" && req.State != "declined" {
		c.JSON(http.StatusBadRequest, "invalid state")
		return
	}
	var invitationService = service.NewInvitationService(ctl.invService.GetDB())
	invitationByID, err := invitationService.GetInvitationById(req.InvitationId)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return

	}

	userIDFromToken, exists := c.Get("userID")
	if !exists || invitationByID.UserID != userIDFromToken && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return

	}
	invitation, err := ctl.invService.UpdateInvitation(int(req.InvitationId), req.State)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"result": invitation,
	})
}

func NewInvitationController(invService service.InvitationService) *InvitationController {
	return &InvitationController{invService: invService}
}
