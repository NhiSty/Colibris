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

func (s *TaskService) getTaskById(id int) (*Task, error) {
	return s.repo.GetById(id)
}

func (s *TaskService) GetAllUserTasks(userId int) ([]Task, error) {
	return s.repo.GetAllUserTasks(userId)
}

func (s *TaskService) UpdateTask(task *Task) error {
	return s.repo.UpdateTask(task)
}
