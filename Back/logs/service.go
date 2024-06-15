package logs

type LogService struct {
	Repo *LogRepository
}

func NewLogService(repo *LogRepository) *LogService {
	return &LogService{Repo: repo}
}

func (service *LogService) CreateLog(log *Log) error {
	return service.Repo.CreateLog(log)
}

func (service *LogService) GetLogs() ([]Log, error) {
	return service.Repo.GetLogs()
}
