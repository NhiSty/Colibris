package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"net/http"
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

	if !taskInColocation {
		c.JSON(http.StatusBadRequest, "You can't vote for a task that is not in your colocation")
		return
	}

	// Check if the task is already voted
	_, err = ctl.voteService.GetVoteByTaskIdAndUserId(int(req.TaskID), int(userIDFromToken.(uint)))
	if err == nil {
		c.JSON(http.StatusBadRequest, "This task is already voted by you")
		return
	}

	// Check if the user is not voting for himself
	if task.UserID == userIDFromToken {
		c.JSON(http.StatusBadRequest, "You can't vote for yourself")
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

	c.JSON(http.StatusCreated, gin.H{
		"Message": "vote added successfully",
	})

}

func NewVoteController(voteService service.VoteService) *VoteController {
	return &VoteController{voteService: voteService}
}
