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

func (t *TaskService) GetAllTasks(page int, pageSize int) ([]model.Task, int64, error) {
	var tasks []model.Task
	var total int64

	t.db.Model(&model.Task{}).Count(&total)
	if page == 0 || pageSize == 0 {
		result := t.db.Find(&tasks)
		return tasks, total, result.Error
	}

	offset := (page - 1) * pageSize
	result := t.db.Limit(pageSize).Offset(offset).Find(&tasks)
	return tasks, total, result.Error
}

func (t *TaskService) SearchTasks(query string) ([]model.Task, error) {
	var tasks []model.Task
	result := t.db.Where("title LIKE ? OR description LIKE ?", "%"+query+"%", "%"+query+"%").Find(&tasks)
	return tasks, result.Error
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

func (t *TaskService) UpdateTask(taskId uint, taskUpdates map[string]interface{}) (*model.Task, error) {
	var task model.Task
	if err := t.db.Model(&task).Where("id = ?", taskId).Updates(taskUpdates).Error; err != nil {
		return nil, err
	}
	if err := t.db.Where("id = ?", taskId).First(&task).Error; err != nil {
		return nil, err
	}

	return &task, nil
}

func (t *TaskService) DeleteTask(id int) error {

	errTaskAndVote := t.DeleteVotes(uint(id))
	if errTaskAndVote != nil {
		return errTaskAndVote
	}

	return t.db.Where("id = ?", id).Delete(&model.Task{}).Error
}

func (t *TaskService) DeleteVotes(id uint) error {
	return t.db.Where("task_id = ?", id).Delete(&model.Vote{}).Error
}
