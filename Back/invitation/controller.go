package invitations

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

type Controller struct {
	invService InvitationService
}

func (ctl *Controller) CreateInvitation(c *gin.Context) {
	var req InvitationCreateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	user, err := ctl.invService.GetUserByEmail(req.Email)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	// verify that the user is not inviting himself and that the user is not already in the colocation
	userIDFromToken, exists := c.Get("userID")
	if !exists || userIDFromToken.(uint) == user.ID {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to invite yourself"})
		return
	}

	// verify that the user is not already in the colocation
	for _, member := range user.Colocations {
		for _, colocation := range member.ColocMembers {
			if colocation.ColocationID == req.ColocationID {
				c.JSON(http.StatusForbidden, gin.H{"error": "User is already a member of the colocation"})
				return
			}
		}

	}

	invitation := Invitation{
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

func (ctl *Controller) GetAllUserInvitation(c *gin.Context) {

	userId, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	userIDFromToken, exists := c.Get("userID")
	if !exists || userIDFromToken.(uint) != uint(userId) {
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

func (ctl *Controller) UpdateInvitation(c *gin.Context) {
	var req InvitationUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	// verify that the state is valid
	if req.State != "accepted" && req.State != "declined" {
		c.JSON(http.StatusBadRequest, "invalid state")
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

func NewInvitationController(invService InvitationService) *Controller {
	return &Controller{invService: invService}
}
