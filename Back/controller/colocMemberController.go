package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"Colibris/utils"
	"fmt"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"strconv"
)

type ColocMemberController struct {
	colocService service.ColocMemberService
	userService  service.UserService
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

	user, _ := ctl.userService.GetUserById(req.UserID)

	fcmToken := user.FcmToken

	firebaseClient, err := utils.NewFirebaseClient()
	if err != nil {
		log.Printf("error initializing Firebase client: %v\n", err)
		fmt.Println(http.StatusInternalServerError, gin.H{"error": "Failed to initialize Firebase client"})
		return
	}

	err = firebaseClient.SubscribeToTopic(fcmToken, int(req.ColocationID))
	if err != nil {
		log.Printf("error subscribing to topic: %v\n", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to subscribe to topic"})
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

// GetAllColocMembers fetches all colocation members from the database with pagination
// @Summary Get all colocation members
// @Description Get all colocation members
// @Tags colocMembers
// @Accept json
// @Produce json
// @Param page query int false "Page number"
// @Param pageSize query int false "Page size"
// @Success 200 {array} model.ColocMember
// @Failure 400 {object} error
// @Router /coloc/members [get]
// @Security Bearer
func (ctl *ColocMemberController) GetAllColocMembers(c *gin.Context) {
	if !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	pageParam := c.DefaultQuery("page", "")
	pageSizeParam := c.DefaultQuery("pageSize", "")

	page, err := strconv.Atoi(pageParam)
	if err != nil || page < 1 {
		page = 1
	}

	pageSize, err := strconv.Atoi(pageSizeParam)
	if err != nil || pageSize < 1 {
		pageSize = 5
	}

	colocMembers, total, err := ctl.colocService.GetAllColocMembers(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	response := gin.H{
		"total":        total,
		"colocMembers": colocMembers,
	}

	c.JSON(http.StatusOK, response)
}

// GetAllColocMembersByColoc fetches all colocation members by colocation
// @Summary Get all colocation members by colocation
// @Description Get all colocation members by colocation
// @Tags colocMembers
// @Accept json
// @Produce json
// @Param colocId path int true "Colocation ID"
// @Success 200 {array} model.ColocMember
// @Failure 400 {object} error
// @Router /coloc/members/colocation/{colocId} [get]
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

	userServce := service.NewUserService(ctl.colocService.GetDB())
	users, _, err := userServce.GetAllUsers(0, 0)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	usersInColoc := make([]dto.UserInColoc, 0)

	// Find the user in the list of users

	for _, colocMember := range colocMembers {
		for _, user := range users {
			if colocMember.UserID == user.ID {
				var userData = dto.UserInColoc{
					ID:            user.ID,
					Email:         user.Email,
					FirstName:     user.Firstname,
					LastName:      user.Lastname,
					Score:         int(colocMember.Score),
					ColocMemberID: colocMember.ID,
				}
				usersInColoc = append(usersInColoc, userData)

			}
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"result": usersInColoc,
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

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid member ID"})
		return
	}

	colocMember, err := ctl.colocService.GetColocMemberById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	colocService := service.NewColocationService(ctl.colocService.GetDB())
	coloc, err := colocService.GetColocationById(int(colocMember.ColocationID))
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	userIdFromToken := c.MustGet("userID").(uint)
	if coloc.UserID != userIdFromToken && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	if err := ctl.colocService.DeleteColocMember(id); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	userService := service.NewUserService(ctl.colocService.GetDB())
	user, err := userService.GetUserById(colocMember.UserID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	firebaseClient, err := utils.NewFirebaseClient()
	if err != nil {
		log.Printf("error initializing Firebase client: %v\n", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to initialize Firebase client"})
		return
	}

	err = firebaseClient.UnsubscribeFromTopic(user.FcmToken, int(colocMember.ColocationID))
	if err != nil {
		log.Printf("error unsubscribing from topic: %v\n", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to unsubscribe from topic"})
		return
	}

	c.JSON(http.StatusNoContent, gin.H{
		"message": "colocation member deleted successfully",
	})
}

// SearchColocMembers allows to search colocation members
// @Summary Search colocation members
// @Description Search colocation members
// @Tags colocMembers
// @Accept json
// @Produce json
// @Param query query string true "Search query"
// @Param page query int false "Page number"
// @Param pageSize query int false "Page size"
// @Success 200 {array} model.ColocMember
// @Failure 400 {object} error
// @Router /coloc/members/search [get]
// @Security Bearer
func (ctl *ColocMemberController) SearchColocMembers(c *gin.Context) {
	query := c.DefaultQuery("query", "")
	pageParam := c.DefaultQuery("page", "1")
	pageSizeParam := c.DefaultQuery("pageSize", "5")

	page, err := strconv.Atoi(pageParam)
	if err != nil || page < 1 {
		page = 1
	}

	pageSize, err := strconv.Atoi(pageSizeParam)
	if err != nil || pageSize < 1 {
		pageSize = 5
	}

	colocMembers, total, err := ctl.colocService.SearchColocMembers(query, page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"total":        total,
		"colocMembers": colocMembers,
	})
}

func NewColocMemberController(colocMemberService service.ColocMemberService, userService *service.UserService) *ColocMemberController {
	return &ColocMemberController{colocService: colocMemberService, userService: *userService}
}
