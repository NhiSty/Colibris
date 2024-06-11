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
		UserID:       req.UserId,
		Description:  req.Description,
		ColocationID: req.ColocationId,
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
	// Get task id
	taskId := c.Param("id")

	// Convert task id to uint
	id, err := strconv.ParseUint(taskId, 10, 32)

	if err != nil {
		c.JSON(http.StatusBadRequest, "Invalid task ID")
		return
	}

	// Get task by id in database
	task, taskErr := ctl.taskService.getTaskById(uint(id))

	if taskErr != nil {
		c.JSON(http.StatusNotFound, taskErr.Error())
		return
	}

	// Return the task
	c.JSON(http.StatusOK, gin.H{
		"result": task,
	})
}

func (ctl *TaskController) GetAllUserTasks(c *gin.Context) {
	// Get user id
	userId := c.Params.ByName("userId")

	// Convert user id to uint
	id, err := strconv.ParseUint(userId, 10, 32)

	if err != nil {
		c.JSON(http.StatusBadRequest, "Invalid user ID")
		return
	}

	// Get all tasks of the user
	tasks, taskError := ctl.taskService.GetAllUserTasks(uint(id))

	if taskError != nil {
		c.JSON(http.StatusNotFound, taskError.Error())
		return
	}

	// Return the tasks
	c.JSON(http.StatusOK, gin.H{
		"result": tasks,
	})
}

func (ctl *TaskController) UpdateTask(c *gin.Context) {

	// Get task id
	taskID := c.Param("id")

	//Convert task id ti uint
	id, err := strconv.ParseUint(taskID, 10, 32)

	if err != nil {
		c.JSON(http.StatusBadRequest, "Invalid task ID")
		return
	}

	// Get new task data from request
	var req TaskUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	// Get task by id in database
	var task Task
	if _, err := ctl.taskService.getTaskById(uint(id)); err != nil {
		c.JSON(http.StatusNotFound, "Task not found")
		return
	}

	// Update task data with new data
	if req.Title != nil {
		task.Title = *req.Title
	}
	if req.Description != nil {
		task.Description = *req.Description
	}
	if req.Date != nil {
		task.Date = *req.Date
	}
	if req.Duration != nil {
		task.Duration = *req.Duration
	}
	if req.Picture != nil {
		task.Picture = *req.Picture
	}

	// Save the updated task in database
	if err := ctl.taskService.UpdateTask(uint(id), &task); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	// Return the updated task
	c.JSON(http.StatusOK, gin.H{
		"Message": "task updated successfully",
		"result":  task,
	})
}
