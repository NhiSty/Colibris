package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

type TaskController struct {
	service *service.TaskService
}

func NewTaskController(service *service.TaskService) *TaskController {
	return &TaskController{
		service: service,
	}
}

func (ctl *TaskController) CreateTask(c *gin.Context) {
	var req dto.TaskCreateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	task := model.Task{
		Title:        req.Title,
		UserID:       req.UserId,
		Description:  req.Description,
		ColocationID: req.ColocationId,
		Date:         req.Date,
		Duration:     req.Duration,
		Picture:      req.Picture,
	}

	if err := ctl.service.CreateTask(&task); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"Message": "task created successfully",
		"result":  task,
	})
}

func (ctl *TaskController) GetTaskById(c *gin.Context) {

	taskId := c.Param("id")
	id, err := strconv.ParseUint(taskId, 10, 32)

	if err != nil {
		c.JSON(http.StatusBadRequest, "Invalid task ID")
		return
	}

	task, taskErr := ctl.service.GetById(uint(id))

	if taskErr != nil {
		c.JSON(http.StatusNotFound, taskErr.Error())
		return
	}

	userIDFromToken, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	colocationService := service.NewColocationService(ctl.service.GetDB())
	colocation, colocationErr := colocationService.GetColocationById(int(task.ColocationID))

	if colocationErr != nil {
		c.JSON(http.StatusNotFound, colocationErr.Error())
		return
	}

	colocationMembers := colocation.ColocMembers
	isMember := false
	for _, member := range colocationMembers {
		if member.UserID == userIDFromToken.(uint) {
			isMember = true
			break
		}
	}

	if !isMember && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"result": task,
	})
}

func (ctl *TaskController) GetAllUserTasks(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("userId"))

	if err != nil {
		c.JSON(http.StatusBadRequest, "Invalid user ID")
		return
	}

	userIDFromToken, exists := c.Get("userID")
	if !exists || userIDFromToken.(uint) != uint(id) && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	tasks, taskError := ctl.service.GetAllUserTasks(uint(id))

	if taskError != nil {
		c.JSON(http.StatusNotFound, taskError.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"result": tasks,
	})
}

func (ctl *TaskController) GetAllCollocationTasks(c *gin.Context) {
	colocationId, err := strconv.Atoi(c.Params.ByName("colocationId"))
	userIDFromToken, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid collocation ID"})
		return
	}

	colocationService := service.NewColocationService(ctl.service.GetDB())
	colocation, colocationErr := colocationService.GetColocationById(colocationId)

	if colocationErr != nil {
		c.JSON(http.StatusNotFound, colocationErr.Error())
		return
	}

	colocationMembers := colocation.ColocMembers
	isMember := false
	for _, member := range colocationMembers {

		if member.UserID == userIDFromToken.(uint) {
			isMember = true
			break
		}
	}

	if !isMember && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	tasks, taskError := ctl.service.GetAllColocationTasks(uint(colocationId))

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

	id, err := strconv.Atoi(c.Params.ByName("id"))

	if err != nil {
		c.JSON(http.StatusBadRequest, "Invalid task ID")
		return
	}

	var req dto.TaskUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		return
	}

	var task model.Task
	if _, err := ctl.service.GetById(uint(id)); err != nil {
		c.JSON(http.StatusNotFound, "Task not found")
		return
	}

	// very that the user is the owner of the task or an admin or the owner of the colocation
	userIDFromToken, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	colocationService := service.NewColocationService(ctl.service.GetDB())
	colocation, colocationErr := colocationService.GetColocationById(int(task.ColocationID))

	if colocationErr != nil {
		c.JSON(http.StatusNotFound, colocationErr.Error())
		return
	}

	colocationMembers := colocation.ColocMembers
	isMember := false
	isOwner := colocation.UserID == userIDFromToken.(uint)
	for _, member := range colocationMembers {
		if member.UserID == userIDFromToken.(uint) {
			isMember = true
			break
		}
	}

	if !isMember && !service.IsAdmin(c) && !isOwner {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

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

	if err := ctl.service.UpdateTask(uint(id), &task); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "task updated successfully",
		"result":  task,
	})
}
