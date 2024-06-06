package colocMembers

import (
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

	colocMember := ColocMember{
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

func NewColocMemberController(colocMemberService ColocMemberService) *ColocMemberController {
	return &ColocMemberController{colocMemberService: colocMemberService}
}
