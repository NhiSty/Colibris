package service

import (
	"Colibris/model"
	"gorm.io/gorm"
)

type TaskService struct {
	db *gorm.DB
}

func (t *TaskService) GetDB() *gorm.DB {
	return t.db
}

func NewTaskService(db *gorm.DB) *TaskService {
	return &TaskService{
		db: db,
	}
}

func (t *TaskService) GetById(id uint) (*model.Task, error) {
	var task model.Task
	result := t.db.Where("id = ?", id).First(&task)
	return &task, result.Error
}

func (t *TaskService) CreateTask(task *model.Task) error {
	return t.db.Create(task).Error
}

func (t *TaskService) GetAllUserTasks(userId uint) ([]model.Task, error) {
	var tasks []model.Task
	result := t.db.Where("user_id = ?", userId).Find(&tasks)
	return tasks, result.Error
}

func (t *TaskService) GetAllColocationTasks(colocationId uint) ([]model.Task, error) {
	var tasks []model.Task
	result := t.db.Where("colocation_id = ?", colocationId).Find(&tasks)
	return tasks, result.Error
}

func (t *TaskService) UpdateTask(taskId uint, task *model.Task) error {
	return t.db.Model(&task).Where("id = ?", taskId).Updates(task).Error
}
