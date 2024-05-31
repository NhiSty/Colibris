package tasks

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

type TaskController struct {
	taskService TaskService
}

func NewTaskController(taskService TaskService) *TaskController {
	return &TaskController{taskService: taskService}
}

func (ctl *TaskController) CreateTask(c *gin.Context) {
	var req TaskCreateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	task := Task{
		Title:        req.Title,
		UserId:       req.UserId,
		Description:  req.Description,
		ColocationId: req.ColocationId,
		Date:         req.Date,
		Duration:     req.Duration,
		Picture:      req.Picture,
	}

	if err := ctl.taskService.createTask(&task); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"Message": "task created successfully",
		"result":  task,
	})
}

func (ctl *TaskController) GetTaskById(c *gin.Context) {

	id, err := strconv.Atoi(c.Params.ByName("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
	}
	task, err := ctl.taskService.getTaskById(id)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
	}

	c.JSON(http.StatusOK, gin.H{
		"result": task,
	})
}

func (ctl *TaskController) GetAllUserTasks(c *gin.Context) {

	userId, err := strconv.Atoi(c.Params.ByName("userId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
	}
	tasks, err := ctl.taskService.GetAllUserTasks(userId)
	if err != nil {
		c.JSON(http.StatusNotFound, err.Error())
	}

	c.JSON(http.StatusOK, gin.H{
		"result": tasks,
	})
}

func (ctl *TaskController) UpdateTask(c *gin.Context) {
	var req TaskCreateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	task := Task{
		Title:        req.Title,
		UserId:       req.UserId,
		Description:  req.Description,
		ColocationId: req.ColocationId,
		Date:         req.Date,
		Duration:     req.Duration,
		Picture:      req.Picture,
	}

	if err := ctl.taskService.UpdateTask(&task); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "task updated successfully",
		"result":  task,
	})
}
