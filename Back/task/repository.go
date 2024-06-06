package tasks

import "gorm.io/gorm"

type TaskRepository interface {
	GetById(id uint) (*Task, error)
	GetAllUserTasks(userId uint) ([]Task, error)
	CreateTask(task *Task) error
	UpdateTask(taskId uint, task *Task) error
}

type taskRepository struct {
	db *gorm.DB
}

func (r *taskRepository) GetById(id uint) (*Task, error) {
	var task Task
	result := r.db.Where("id = ?", id).First(&task)
	return &task, result.Error
}

func (r *taskRepository) CreateTask(task *Task) error {
	return r.db.Create(task).Error
}

func (r *taskRepository) GetAllUserTasks(userId uint) ([]Task, error) {
	var tasks []Task
	result := r.db.Where("user_id = ?", userId).Find(&tasks)
	return tasks, result.Error
}

func (r *taskRepository) UpdateTask(taskId uint, task *Task) error {
	return r.db.Model(&task).Where("id = ?", taskId).Updates(task).Error
}

func NewTaskRepository(db *gorm.DB) TaskRepository {
	return &taskRepository{db: db}
}
