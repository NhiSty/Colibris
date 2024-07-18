package service

import (
	"Colibris/model"
	"gorm.io/gorm"
)

type UserService struct {
	db *gorm.DB
}

func NewUserService(db *gorm.DB) *UserService {
	return &UserService{
		db: db,
	}
}

func (s *UserService) GetAllUsers(page int, pageSize int) ([]model.User, int64, error) {
	var users []model.User
	var total int64

	s.db.Model(&model.User{}).Count(&total)

	if page == 0 || pageSize == 0 {
		result := s.db.Find(&users)
		return users, total, result.Error
	}

	offset := (page - 1) * pageSize
	result := s.db.Limit(pageSize).Offset(offset).Find(&users)
	return users, total, result.Error
}

func (s *UserService) GetUserById(id uint) (*model.User, error) {
	var user model.User
	result := s.db.Where("id = ?", id).First(&user)
	return &user, result.Error
}

func (s *UserService) GetUserByEmail(email string) (*model.User, error) {
	var user model.User
	result := s.db.Where("email = ?", email).First(&user)
	return &user, result.Error
}

func (s *UserService) UpdateUser(id uint, userUpdates map[string]interface{}) (*model.User, error) {
	var user model.User
	if err := s.db.Model(&user).Where("id = ?", id).Updates(userUpdates).Error; err != nil {
		return nil, err
	}
	if err := s.db.Where("id = ?", id).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func (s *UserService) SearchUsers(query string) ([]model.User, error) {
	var users []model.User
	result := s.db.Where("firstname LIKE ? OR lastname LIKE ? OR email LIKE ?", "%"+query+"%", "%"+query+"%", "%"+query+"%").Find(&users)
	return users, result.Error
}

func (s *UserService) AddUser(user *model.User) error {
	return s.db.Create(user).Error
}

func (s *UserService) GetDB() *gorm.DB {
	return s.db
}

func (s *UserService) DeleteUserById(id uint) error {
	var colocations []model.Colocation
	err := s.db.Where("user_id = ?", id).Find(&colocations).Error
	if err != nil {
		return err
	}

	for _, colocation := range colocations {
		// Delete tasks and their votes
		err = s.DeleteTasksAndVotes(colocation.ID)
		if err != nil {
			return err
		}

		// Delete colocMembers
		err = s.DeleteColocMembers(colocation.ID)
		if err != nil {
			return err
		}

		// Delete the colocation itself
		err = s.db.Delete(&colocation).Error
		if err != nil {
			return err
		}
	}

	// Finally, delete the user
	return s.db.Delete(&model.User{}, id).Error
}

func (s *UserService) DeleteTasksAndVotes(colocationID uint) error {
	var tasks []model.Task
	err := s.db.Where("colocation_id = ?", colocationID).Find(&tasks).Error
	if err != nil {
		return err
	}

	for _, task := range tasks {
		// Delete votes for each task
		var votes []model.Vote
		err = s.db.Where("task_id = ?", task.ID).Find(&votes).Error
		if err != nil {
			return err
		}

		for _, vote := range votes {
			err = s.db.Delete(&vote).Error
			if err != nil {
				return err
			}
		}

		// Delete the task itself
		err = s.db.Delete(&task).Error
		if err != nil {
			return err
		}
	}

	return nil
}

func (s *UserService) DeleteColocMembers(colocationID uint) error {
	var colocMembers []model.ColocMember
	err := s.db.Where("colocation_id = ?", colocationID).Find(&colocMembers).Error
	if err != nil {
		return err
	}

	for _, colocMember := range colocMembers {
		err = s.db.Delete(&colocMember).Error
		if err != nil {
			return err
		}
	}

	return nil
}
