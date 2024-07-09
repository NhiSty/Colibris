package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"math"
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
	pts := float64(req.Duration) * .025
	task := model.Task{
		Title:        req.Title,
		UserID:       req.UserId,
		Description:  req.Description,
		ColocationID: req.ColocationId,
		Date:         req.Date,
		Duration:     req.Duration,
		Picture:      req.Picture,
		Pts:          math.Round(pts),
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

	// check if the task exists
	task, err := ctl.service.GetById(uint(id))
	if err != nil {
		c.JSON(http.StatusNotFound, "Task not found")
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

	taskUpdate := make(map[string]interface{})
	if req.Title != "" {
		taskUpdate["title"] = req.Title
	}
	if req.Description != "" {
		taskUpdate["description"] = req.Description
	}
	if req.Date != "" {
		taskUpdate["date"] = req.Date
	}
	if req.Duration != 0 {
		taskUpdate["duration"] = req.Duration
		pts := float64(req.Duration) * .025
		taskUpdate["pts"] = math.Round(pts)
	}
	if req.Picture != "" {
		taskUpdate["picture"] = req.Picture
	}

	if _, err := ctl.service.UpdateTask(uint(id), taskUpdate); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "task updated successfully",
		"result":  task,
	})
}

func (ctl *TaskController) DeleteTask(c *gin.Context) {
	id, err := strconv.Atoi(c.Params.ByName("id"))

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid task ID"})
		return
	}

	task, err := ctl.service.GetById(uint(id))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Task not found"})
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
		c.JSON(http.StatusNotFound, gin.H{"error 2": "Colocation not found"})
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

	if err := ctl.service.DeleteTask(uint(id)); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error 1": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "task deleted successfully",
	})
}
