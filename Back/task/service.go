package tasks

type TaskService struct {
	repo TaskRepository
}

func NewTaskService(repo TaskRepository) TaskService {
	return TaskService{repo: repo}
}

func (s *TaskService) createTask(task *Task) error {
	return s.repo.CreateTask(task)
}

func (s *TaskService) getTaskById(id uint) (*Task, error) {
	return s.repo.GetById(id)
}

func (s *TaskService) GetAllUserTasks(userId uint) ([]Task, error) {
	return s.repo.GetAllUserTasks(userId)
}

func (s *TaskService) GetAllColocationTasks(colocationId uint) ([]Task, error) {
	return s.repo.GetAllColocationTasks(colocationId)
}

func (s *TaskService) UpdateTask(taskId uint, task *Task) error {
	return s.repo.UpdateTask(taskId, task)
}
