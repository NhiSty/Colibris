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

func (ctl *VoteController) AddVote(c *gin.Context) {
	var req dto.VoteCreateRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	userIDFromToken, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, "Unauthorized")
		return
	}

	// Recover colocMember by userId
	var colocMemberService = service.NewColocMemberService(ctl.voteService.GetDB())
	colocMember, err := colocMemberService.GetColocMemberByUserId(int(userIDFromToken.(uint)))

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	var taskService = service.NewTaskService(ctl.voteService.GetDB())
	task, err := taskService.GetById(req.TaskID)

	// Check if the task exists
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
		c.JSON(http.StatusBadRequest, "error_votingTaskCantVoteForTaskNotInYourColocation")
		return
	}

	// Check if the task is already voted
	_, err = ctl.voteService.GetVoteByTaskIdAndUserId(int(req.TaskID), int(userIDFromToken.(uint)))
	if err == nil {
		c.JSON(http.StatusBadRequest, "error_votingTaskAlreadyVoted")
		return
	}

	// Check if the user is not voting for himself
	if task.UserID == userIDFromToken {
		c.JSON(http.StatusBadRequest, "error_votingTaskCantVoteForYourself")
		return
	}

	var limitDate = time.Now().AddDate(0, 0, -3)

	if task.CreatedAt.Before(limitDate) && !service.IsAdmin(c) {
		c.JSON(http.StatusUnprocessableEntity, "error_votingTaskOver3DaysOld")
		return
	}

	vote := model.Vote{
		UserID: userIDFromToken.(uint),
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

	// verify if the user is the owner of the colocation
	userIDFromToken, exists := c.Get("userID")
	if !exists && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Unauthorized"})
		return
	}

	// Recover colocMember by userId
	var colocMemberService = service.NewColocMemberService(ctl.voteService.GetDB())
	colocMember, err := colocMemberService.GetColocMemberByUserId(int(userIDFromToken.(uint)))

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	vote, err := ctl.voteService.GetVoteById(voteId)

	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
		return
	}

	if vote.UserID != userIDFromToken.(uint) && !service.IsAdmin(c) {
		c.JSON(http.StatusUnauthorized, "Unauthorized")
		return
	}

	var taskService = service.NewTaskService(ctl.voteService.GetDB())
	task, err := taskService.GetById(vote.TaskID)

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
		c.JSON(http.StatusBadRequest, "error_votingTaskCantVoteForTaskNotInYourColocation")
		return
	}

	if task.UserID == userIDFromToken {
		c.JSON(http.StatusBadRequest, "error_votingTaskCantVoteForYourself")
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

	if _, err := ctl.voteService.UpdateVote(voteId, voteUpdates); err != nil {
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
		"Message": "vote updated successfully",
	})
}

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

func NewVoteController(voteService service.VoteService) *VoteController {
	return &VoteController{voteService: voteService}
}
