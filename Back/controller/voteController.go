package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"time"
)

type VoteController struct {
	voteService service.VoteService
}

// AddVote allows to add a vote to a task
// @Summary Add a vote to a task
// @Description Add a vote to a task
// @Tags votes
// @Accept json
// @Produce json
// @Param vote body dto.VoteCreateRequest true "Vote object"
// @Success 201 {object} dto.VoteCreateRequest
// @Failure 400 {object} error
// @Failure 400 {string} string "error_votingTaskCantVoteForTaskNotInYourColocation"
// @Failure 400 {string} string "error_votingTaskCantVoteForYourself"
// @Failure 400 {string} string "error_votingTaskAlreadyVoted"
// @Failure 401 {string} string "Unauthorized"
// @Failure 404 {object} error
// @Failure 422 {string} string "error_votingTaskOver3DaysOld"
// @Failure 500 {object} error
// @Router /votes [post]
// @Security Bearer
func (ctl *VoteController) AddVote(c *gin.Context) {
	var req dto.VoteCreateRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	userIDFromToken, exists := c.Get("userID")
	if !exists && !service.IsAdmin(c) {
		c.JSON(http.StatusUnauthorized, "Unauthorized")
		return
	}

	var userId int

	if service.IsAdmin(c) {
		userId = int(req.UserID)
	} else {
		userId = int(userIDFromToken.(uint))
	}

	var taskService = service.NewTaskService(ctl.voteService.GetDB())
	task, err := taskService.GetById(req.TaskID)

	// Check if the task exists
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	// Recover colocMember by userId
	var colocMemberService = service.NewColocMemberService(ctl.voteService.GetDB())
	colocMember, err := colocMemberService.GetColocMemberByUserId(int(task.UserID))

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	var colocService = service.NewColocationService(ctl.voteService.GetDB())
	colocations, err := colocService.GetAllUserColocations(userId)

	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	// Check if task is in the same colocation as the user
	taskInColocation := false
	for _, colocation := range colocations {
		if colocation.ID == task.ColocationID {
			taskInColocation = true
			break
		}
	}

	if !taskInColocation && !service.IsAdmin(c) {
		c.JSON(http.StatusUnprocessableEntity, "error_votingTaskCantVoteForTaskNotInYourColocation")
		return
	}

	// Check if the task is already voted
	_, err = ctl.voteService.GetVoteByTaskIdAndUserId(int(req.TaskID), userId)
	if err == nil {
		c.JSON(http.StatusUnprocessableEntity, "error_votingTaskAlreadyVoted")
		return
	}

	// Check if the user is not voting for himself
	if task.UserID == userIDFromToken && !service.IsAdmin(c) {
		c.JSON(http.StatusUnprocessableEntity, "error_votingTaskCantVoteForYourself")
		return
	}

	var limitDate = time.Now().AddDate(0, 0, -3)

	if task.CreatedAt.Before(limitDate) && !service.IsAdmin(c) {
		c.JSON(http.StatusUnprocessableEntity, "error_votingTaskOver3DaysOld")
		return
	}

	vote := model.Vote{
		UserID: uint(userId),
		TaskID: req.TaskID,
		Value:  req.Value,
	}

	if err := ctl.voteService.AddVote(&vote); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	// Get all votes by taskId
	votes, err := ctl.voteService.GetVotesByTaskId(int(req.TaskID))
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	var positiveVotes = 0
	var negativeVotes = 0

	// make percentage of votes positive (1) and negative (-1)

	for _, vote := range votes {
		if vote.Value == 1 {
			positiveVotes += 1
		} else {
			negativeVotes += 1
		}

	}

	var colocMemberNewScore = colocMember.Score
	var taskWithNewValidation = make(map[string]interface{})

	var percentagePositiveVotes = (positiveVotes / len(votes)) * 100
	var percentageNegativeVotes = (negativeVotes / len(votes)) * 100

	// if more than 50% of votes are positive, the task is validated and the score of the colocMember is incremented, but only one time
	if percentagePositiveVotes > 50 && task.Validate == false {
		taskWithNewValidation["validate"] = true
		colocMemberNewScore += float32(task.Pts)
	} else if percentageNegativeVotes >= 50 && task.Validate == true {
		taskWithNewValidation["validate"] = false
		colocMemberNewScore = colocMemberNewScore - float32(task.Pts)
	}

	if err := colocMemberService.UpdateColocMemberScore(int(colocMember.ID), colocMemberNewScore); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	if _, err := taskService.UpdateTask(req.TaskID, taskWithNewValidation); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"Message": "vote added successfully",
	})

}

// UpdateVote allows to update a vote
// @Summary Update a vote
// @Description Update a vote
// @Tags votes
// @Accept json
// @Produce json
// @Param voteId path int true "Vote ID"
// @Param vote body dto.VoteUpdateRequest true "Vote object"
// @Success 200 {object} dto.VoteUpdateRequest
// @Failure 400 {object} error
// @Failure 400 {string} string "error_votingTaskCantVoteForTaskNotInYourColocation"
// @Failure 400 {string} string "error_votingTaskCantVoteForYourself"
// @Failure 403 {string} string "Unauthorized"
// @Failure 401 {string} string "Unauthorized"
// @Failure 404 {object} error
// @Failure 422 {string} string "error_votingTaskOver3DaysOld"
// @Failure 500 {object} error
// @Router /votes/{voteId} [put]
// @Security Bearer
func (ctl *VoteController) UpdateVote(c *gin.Context) {
	var req dto.VoteUpdateRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	voteId, err := strconv.Atoi(c.Params.ByName("voteId"))

	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	vote, err := ctl.voteService.GetVoteById(voteId)

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	// verify if the user is the owner of the colocation
	userIDFromToken, exists := c.Get("userID")
	if !exists && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Unauthorized"})
		return
	}

	var userId int

	if !service.IsAdmin(c) {
		userId = int(userIDFromToken.(uint))
	} else {
		userId = int(vote.UserID)
	}

	var taskService = service.NewTaskService(ctl.voteService.GetDB())
	task, err := taskService.GetById(vote.TaskID)

	// Recover colocMember by userId
	var colocMemberService = service.NewColocMemberService(ctl.voteService.GetDB())
	colocMember, err := colocMemberService.GetColocMemberByUserId(int(task.UserID))

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	if vote.UserID != userIDFromToken.(uint) && !service.IsAdmin(c) {
		c.JSON(http.StatusUnauthorized, "Unauthorized")
		return
	}

	var colocService = service.NewColocationService(ctl.voteService.GetDB())
	colocations, err := colocService.GetAllUserColocations(userId)

	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	// Check if task is in the same colocation as the user
	taskInColocation := false
	for _, colocation := range colocations {
		if colocation.ID == task.ColocationID {
			taskInColocation = true
			break
		}
	}

	if !taskInColocation && !service.IsAdmin(c) {
		c.JSON(http.StatusBadRequest, "error_votingTaskCantVoteForTaskNotInYourColocation")
		return
	}

	if task.UserID == uint(userId) {
		c.JSON(http.StatusUnprocessableEntity, "error_votingTaskCantVoteForYourself")
		return
	}

	var limitDate = time.Now().AddDate(0, 0, -3)

	if task.CreatedAt.Before(limitDate) && !service.IsAdmin(c) {
		c.JSON(http.StatusUnprocessableEntity, "error_votingTaskOver3DaysOld")
		return
	}

	voteUpdates := make(map[string]interface{})

	if req.Value != 0 {
		voteUpdates["value"] = req.Value
	}

	voteUpdated, err := ctl.voteService.UpdateVote(voteId, voteUpdates)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	// Get all votes by taskId
	votes, err := ctl.voteService.GetVotesByTaskId(int(task.ID))
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	var positiveVotes = 0
	var negativeVotes = 0

	// make percentage of votes positive (1) and negative (-1)

	for _, vote := range votes {
		if vote.Value == 1 {
			positiveVotes += 1
		} else {
			negativeVotes += 1
		}

	}

	var colocMemberNewScore = colocMember.Score
	var taskWithNewValidation = make(map[string]interface{})

	var percentagePositiveVotes = (positiveVotes / len(votes)) * 100
	var percentageNegativeVotes = (negativeVotes / len(votes)) * 100

	// if more than 50% of votes are positive, the task is validated and the score of the colocMember is incremented, but only one time
	if percentagePositiveVotes > 50 && task.Validate == false {
		taskWithNewValidation["validate"] = true
		colocMemberNewScore += float32(task.Pts)
	} else if percentageNegativeVotes >= 50 && task.Validate == true {
		taskWithNewValidation["validate"] = false
		colocMemberNewScore = colocMemberNewScore - float32(task.Pts)
	}

	if err := colocMemberService.UpdateColocMemberScore(int(colocMember.ID), colocMemberNewScore); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	if _, err := taskService.UpdateTask(task.ID, taskWithNewValidation); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "backoffice_task_task_updated_successfully",
		"vote":    voteUpdated,
	})
}

// GetVotesByTaskId allows to get all votes by task id
// @Summary Get all votes by task id
// @Description Get all votes by task id
// @Tags votes
// @Produce json
// @Param taskId path int true "Task ID"
// @Success 200 {array} model.Vote
// @Failure 400 {object} error
// @Failure 401 {string} string "Unauthorized"
// @Failure 404 {object} error
// @Failure 500 {object} error
// @Router /votes/task/{taskId} [get]
// @Security Bearer
func (ctl *VoteController) GetVotesByTaskId(c *gin.Context) {
	taskId, err := strconv.Atoi(c.Params.ByName("taskId"))

	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	userIDFromToken, exists := c.Get("userID")

	if !exists && !service.IsAdmin(c) {
		c.JSON(http.StatusUnauthorized, "Unauthorized")
	}

	var taskService = service.NewTaskService(ctl.voteService.GetDB())
	task, err := taskService.GetById(uint(taskId))

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	var colocService = service.NewColocationService(ctl.voteService.GetDB())
	colocations, err := colocService.GetAllUserColocations(int(userIDFromToken.(uint)))

	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	// Check if task is in the same colocation as the user
	taskInColocation := false
	for _, colocation := range colocations {
		if colocation.ID == task.ColocationID {
			taskInColocation = true
			break
		}
	}

	if !taskInColocation && !service.IsAdmin(c) {
		c.JSON(http.StatusBadRequest, "You can't access this resource")
		return
	}

	votes, err := ctl.voteService.GetVotesByTaskId(taskId)

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"votes": votes,
	})
}

// GetVotesByUserId allows to get all votes by user id
// @Summary Get all votes by user id
// @Description Get all votes by user id
// @Tags votes
// @Produce json
// @Param userId path int true "User ID"
// @Success 200 {array} model.Vote
// @Failure 400 {object} error
// @Failure 401 {string} string "Unauthorized"
// @Failure 403 {string} string "You are not allowed to access this resource"
// @Failure 404 {object} error
// @Failure 500 {object} error
// @Router /votes/user/{userId} [get]
// @Security Bearer
func (ctl *VoteController) GetVotesByUserId(c *gin.Context) {
	userId, err := strconv.Atoi(c.Params.ByName("userId"))

	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	userIDFromToken, exists := c.Get("userID")
	if !exists || userIDFromToken.(uint) != uint(userId) && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	votes, err := ctl.voteService.GetVotesByUserId(userId)

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"votes": votes,
	})
}

func (ctl *VoteController) DeleteVote(c *gin.Context) {
	voteId, err := strconv.Atoi(c.Params.ByName("voteId"))

	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	_, err = ctl.voteService.GetVoteById(voteId)

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	if err := ctl.voteService.DeleteVote(voteId); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusNoContent, gin.H{
		"Message": "vote deleted successfully",
	})
}

func NewVoteController(voteService service.VoteService) *VoteController {
	return &VoteController{voteService: voteService}
}
