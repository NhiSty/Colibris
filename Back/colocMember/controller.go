package colocMembers

import (
	"Colibris/models"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

type ColocMemberController struct {
	colocMemberService ColocMemberService
}

func (ctl *ColocMemberController) CreateColocMember(c *gin.Context) {
	var req ColocMemberCreateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	colocMember := models.ColocMember{
		UserID:       req.UserID,
		ColocationID: req.ColocationID,
		Score:        0,
	}

	if err := ctl.colocMemberService.CreateColocMember(&colocMember); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"Message": "colocation member created successfully",
		"result":  colocMember,
	})
}

func (ctl *ColocMemberController) GetColocMemberById(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
	}
	colocMember, err := ctl.colocMemberService.GetColocMemberById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
	}

	c.JSON(http.StatusOK, gin.H{
		"result": colocMember,
	})
}

func (ctl *ColocMemberController) GetAllColocMembers(c *gin.Context) {
	colocMembers, err := ctl.colocMemberService.GetAllColocMembers()
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"colocMembers": colocMembers,
	})
}

func (ctl *ColocMemberController) GetAllColocMembersByColoc(c *gin.Context) {

	// verify that the user is allowed to access this resource
	userIdFromToken, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource ok"})
		return
	}

	// get the coloc from the request and verify that the user is allowed to access this resource

	colocId, err := strconv.Atoi(c.Params.ByName("colocId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	// get the colocation
	coloc, err := ctl.colocMemberService.GetColocationById(colocId)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	// check if the user is allowed to access this resource
	if coloc.UserID != userIdFromToken {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	colocMembers, err := ctl.colocMemberService.GetAllColocMembersByColoc(colocId)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"colocMembers": colocMembers,
	})
}

func (ctl *ColocMemberController) UpdateColocMemberScore(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	var req ColocMemberScoreUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	if err := ctl.colocMemberService.UpdateColocMemberScore(id, req.Score); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "colocation member score updated successfully",
	})
}

func (ctl *ColocMemberController) DeleteColocMember(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))

	colocMember, err := ctl.colocMemberService.GetColocMemberById(id)

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	// get the colocation
	coloc, err := ctl.colocMemberService.GetColocationById(int(colocMember.ColocationID))
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return

	}

	var userIdFromToken uint = c.MustGet("userID").(uint)

	if coloc.UserID != userIdFromToken {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	if err := ctl.colocMemberService.DeleteColocMember(id); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "colocation member deleted successfully",
	})

}

func NewColocMemberController(colocMemberService ColocMemberService) *ColocMemberController {
	return &ColocMemberController{colocMemberService: colocMemberService}
}
