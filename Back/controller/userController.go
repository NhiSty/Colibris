package controller

import (
	"Colibris/dto"
	"Colibris/model"
	"Colibris/service"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"golang.org/x/crypto/bcrypt"
	"net/http"
	"strconv"
)

type UserController struct {
	service   *service.UserService
	validator *validator.Validate
}

func NewUserController(service *service.UserService) *UserController {
	return &UserController{
		service:   service,
		validator: validator.New(),
	}
}

// GetUserById fetches a user by its ID
// @Summary Get a user by ID
// @Description Get a user by ID
// @Tags users
// @Accept json
// @Produce json
// @Param id path int true "User ID"
// @Success 200 {object} model.User
// @Failure 400 {object} error
// @Router /users/{id} [get]
// @Security Bearer
func (ctrl *UserController) GetUserById(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	userIDFromToken, exists := c.Get("userID")
	if !exists || userIDFromToken.(uint) != uint(id) && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}

	user, err := ctrl.service.GetUserById(uint(id))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}
	c.JSON(http.StatusOK, user)
}

// UpdateUser updates a user by its ID
// @Summary Update a user by ID
// @Description Update a user by ID
// @Tags users
// @Accept json
// @Produce json
// @Param id path int true "User ID"
// @Param userUpdates body dto.UpdateUserDTO true "User object"
// @Success 200 {object} model.User
// @Failure 400 {object} error
// @Router /users/{id} [patch]
func (ctrl *UserController) UpdateUser(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	userIDFromToken, exists := c.Get("userID")
	if !exists || userIDFromToken.(uint) != uint(id) && !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to update this resource"})
		return
	}

	var updateUserDTO dto.UpdateUserDTO
	if err := c.ShouldBindJSON(&updateUserDTO); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := ctrl.validator.Struct(updateUserDTO); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userUpdates := make(map[string]interface{})
	if updateUserDTO.Password != "" {
		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(updateUserDTO.Password), bcrypt.DefaultCost)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
			return
		}
		userUpdates["password"] = string(hashedPassword)
	}
	if updateUserDTO.Email != "" {
		userUpdates["email"] = updateUserDTO.Email
	}
	if updateUserDTO.FirstName != "" {
		userUpdates["firstname"] = updateUserDTO.FirstName
	}
	if updateUserDTO.LastName != "" {
		userUpdates["lastname"] = updateUserDTO.LastName
	}

	updatedUser, err := ctrl.service.UpdateUser(uint(id), userUpdates)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, updatedUser)
}

// DeleteUserById deletes a user by its ID
// @Summary Delete a user by ID
// @Description Delete a user by ID
// @Tags users
// @Accept json
// @Produce json
// @Param id path int true "User ID"
// @Success 204 {object} error
// @Failure 400 {object} error
// @Router /users/{id} [delete]
// @Security Bearer
func (ctrl *UserController) DeleteUserById(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))

	if !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to delete this resource"})
		return
	}

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	if err := ctrl.service.DeleteUserById(uint(id)); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusNoContent, gin.H{"message": "User deleted successfully"})
}

// GetAllUsers fetches all users from the database
// @Summary Get all users
// @Description Get all users
// @Tags users
// @Accept json
// @Produce json
// @Success 200 {array} model.User
// @Failure 400 {object} error
// @Router /users [get]
// @Security Bearer
func (ctrl *UserController) GetAllUsers(c *gin.Context) {
	pageParam := c.DefaultQuery("page", "")
	pageSizeParam := c.DefaultQuery("pageSize", "")

	if pageParam == "" && pageSizeParam == "" {
		users, total, err := ctrl.service.GetAllUsers(0, 0)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"total": total, "users": users})
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

	users, total, err := ctrl.service.GetAllUsers(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"total": total, "users": users})
}

func (ctrl *UserController) SearchUsers(c *gin.Context) {
	query := c.DefaultQuery("query", "")

	users, err := ctrl.service.SearchUsers(query)
	if !service.IsAdmin(c) {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to access this resource"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, users)
}

func (ctrl *UserController) AddUser(c *gin.Context) {
	var user model.User
	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := ctrl.service.AddUser(&user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, user)
}

func (ctrl *UserController) GetUserByEmail(c *gin.Context) {
	email := c.Param("email")
	user, err := ctrl.service.GetUserByEmail(email)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}
	c.JSON(http.StatusOK, user)
}

func (ctrl *UserController) AddFcmToken(c *gin.Context) {
	userIDFromToken, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not allowed to update this resource"})
		return
	}

	var requestBody struct {
		FcmToken string `json:"fcm_token" binding:"required"`
	}
	if err := c.ShouldBindJSON(&requestBody); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	userUpdates := map[string]interface{}{
		"fcm_token": requestBody.FcmToken,
	}

	updatedUser, err := ctrl.service.UpdateUser(userIDFromToken.(uint), userUpdates)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, updatedUser)
}

func (ctrl *UserController) UpdateRoleUser(c *gin.Context) {

	type RoleUpdateRequest struct {
		Roles string `json:"roles" binding:"required"`
	}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	var req RoleUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	userUpdates := make(map[string]interface{})
	userUpdates["roles"] = req.Roles

	updatedUser, err := ctrl.service.UpdateUser(uint(id), userUpdates)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, updatedUser)

}

// GetUsersByTaskId Get users all user of colocation by task ID
// @Summary Get all users of colocation by task ID
// @Description Get all users of colocation by task ID
// @Tags users
// @Produce json
// @Param id path int true "Task ID"
// @Success 200 {array} model.User
// @Failure 400 {object} error
// @Failure 500 {object} error
// @Router /users/colocation/{id} [get]
// @Security Bearer
func (ctrl *UserController) GetUsersByTaskId(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("task_id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid task ID"})
		return
	}

	taskService := service.NewTaskService(ctrl.service.GetDB())
	task, err := taskService.GetById(uint(id))

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var colocationId = task.ColocationID

	colocationService := service.NewColocationService(ctrl.service.GetDB())
	colocation, err := colocationService.GetColocationById(int(colocationId))

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	colocMembers := colocation.ColocMembers

	colocMembersUsers := make([]model.User, 0)

	for _, colocMember := range colocMembers {
		colocMemberUser, _ := ctrl.service.GetUserById(colocMember.UserID)
		colocMembersUsers = append(colocMembersUsers, *colocMemberUser)
	}

	c.JSON(http.StatusOK, gin.H{
		"users": colocMembersUsers,
	})
}
