package colocations

import (
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

	colocation := Colocation{
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
	}
	coloc, err := ctl.colocService.getColocationById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
	}

	c.JSON(http.StatusOK, gin.H{
		"result": coloc,
	})
}

func (ctl *Controller) GetAllUserColocations(c *gin.Context) {
	userId, err := strconv.Atoi(c.Params.ByName("userId"))
	colocations, err := ctl.colocService.GetAllUserColocations(userId)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"colocations": colocations,
	})
}
