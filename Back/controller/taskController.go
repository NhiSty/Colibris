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

func (ctl *TaskController) GetAllTasks(c *gin.Context) {
	pageParam := c.DefaultQuery("page", "")
	pageSizeParam := c.DefaultQuery("pageSize", "")

	if pageParam == "" || pageSizeParam == "" {
		tasks, total, err := ctl.service.GetAllTasks(0, 0)
		if err != nil {
			c.JSON(http.StatusInternalServerError, err.Error())
			return
		}
		c.JSON(http.StatusOK, gin.H{"total": total, "tasks": tasks})
		return
	}

	page, err := strconv.Atoi(pageParam)
	if err != nil || page < 1 {
		page = 1
	}

	pageSize, err := strconv.Atoi(pageSizeParam)
	if err != nil || pageSize < 1 {
		pageSize = 5
	}

	tasks, total, err := ctl.service.GetAllTasks(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"total": total,
		"tasks": tasks,
	})

}

// SearchTasks allows to search tasks by title or description
// @Summary Search tasks by title or description
// @Description Search tasks by title or description
// @Tags tasks
// @Produce json
// @Param query query string false "Search query"
// @Success 200 {array} model.Task
// @Failure 403 {object} error
// @Failure 500 {object} error
// @Router /tasks/search [get]
// @Security Bearer
func (ctl *TaskController) SearchTasks(c *gin.Context) {
	query := c.DefaultQuery("query", "")

	if !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Forbidden"})
		return
	}

	tasks, err := ctl.service.SearchTasks(query)

	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, tasks)
}

// CreateTask allows to create a new task
// @Summary Create a new task
// @Description Create a new task
// @Tags tasks
// @Accept json
// @Produce json
// @Param task body dto.TaskCreateRequest true "Task object"
// @Success 201 {object} dto.TaskCreateRequest
// @Failure 400 {object} error
// @Router /tasks [post]
// @Security Bearer
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

// add Comment to swagger

// GetTaskById fetches a task by its ID
// @Summary Get a task by ID
// @Description Get a task by ID
// @Tags tasks
// @Produce json
// @Param id path int true "Task ID"
// @Success 200 {object} model.Task
// @Failure 400 {object} error
// @Failure 404 {object} error
// @Failure 403 {object} error
// @Failure 401 {object} error
// @Router /tasks/{id} [get]
// @Security Bearer
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

// GetAllUserTasks fetches all tasks of a user
// @Summary Get all tasks of a user
// @Description Get all tasks of a user
// @Tags tasks
// @Produce json
// @Param userId path int true "User ID"
// @Success 200 {array} model.Task
// @Failure 400 {object} error
// @Failure 404 {object} error
// @Failure 403 {object} error
// @Router /tasks/user/{userId} [get]
// @Security Bearer
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

// GetAllCollocationTasks fetches all tasks of a colocation
// @Summary Get all tasks of a colocation
// @Description Get all tasks of a colocation
// @Tags tasks
// @Produce json
// @Param colocationId path int true "Colocation ID"
// @Success 200 {array} model.Task
// @Failure 400 {object} error
// @Failure 404 {object} error
// @Failure 403 {object} error
// @Failure 401 {object} error
// @Router /tasks/colocation/{colocationId} [get]
// @Security Bearer
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

// UpdateTask updates a task by its ID
// @Summary Update a task by ID
// @Description Update a task by ID
// @Tags tasks
// @Accept json
// @Produce json
// @Param id path int true "Task ID"
// @Param taskUpdates body dto.TaskUpdateRequest true "Task object"
// @Success 200 {object} dto.TaskUpdateRequest
// @Failure 400 {object} error
// @Failure 404 {object} error
// @Failure 403 {object} error
// @Failure 401 {object} error
// @Router /tasks/{id} [put]
// @Security Bearer
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

	if !service.IsAdmin(c) {
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

	if int(req.ColocationID) != 0 && service.IsAdmin(c) {
		taskUpdate["colocation_id"] = req.ColocationID
	}

	if req.UserID != 0 && service.IsAdmin(c) {
		taskUpdate["user_id"] = req.UserID
	}

	if _, err := ctl.service.UpdateTask(uint(id), taskUpdate); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"Message": "task updated successfully",
		"result":  taskUpdate,
	})
}

// DeleteTask deletes a task by its ID
// @Summary Delete a task by ID
// @Description Delete a task by ID
// @Tags tasks
// @Produce json
// @Param id path int true "Task ID"
// @Success 200 {object} string
// @Failure 400 {object} error
// @Failure 404 {object} error
// @Failure 403 {object} error
// @Failure 401 {object} error
// @Failure 500 {object} error
// @Router /tasks/{id} [delete]
// @Security Bearer
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

	if err := ctl.service.DeleteTask(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error 1": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, gin.H{
		"Message": "task deleted successfully",
	})
}
