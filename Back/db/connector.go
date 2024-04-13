package connector

import (
	"database/sql"
	"fmt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"os"
)

func Connect() *gorm.DB {
	dsn := os.Getenv("DB_URL")
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic(err.Error())
	}
	return db
}

func GetConnection() *gorm.DB {
	psqlDB, err := sql.Open("pgx", os.Getenv("DB_URL"))
	if err != nil {
		panic(err.Error())
	}
	gormDB, err := gorm.Open(postgres.New(postgres.Config{
		Conn: psqlDB,
	}), &gorm.Config{})

	if err != nil {
		panic(err.Error())
	}

	return gormDB
}

func Migrate() {
	db := Connect()

	errDelete := db.Migrator().DropTable(
		&User{},
		&Colocation{},
		&ColocMember{},
		&Chat{},
		&Message{},
		&Service{},
		&AchievedService{})

	if errDelete != nil {
		panic(errDelete.Error())
	}

	err := db.AutoMigrate(
		&User{},
		&Colocation{},
		&ColocMember{},
		&Chat{},
		&Message{},
		&Service{},
		&AchievedService{})

	if err != nil {
		panic(err.Error())
	}

	db.Create(&User{
		Model:       gorm.Model{},
		Email:       "test@test.com",
		Password:    "test",
		Username:    "test",
		Firstname:   "test",
		Lastname:    "test",
		Colocations: nil,
	})

	fmt.Println("Migration complete")
}

type User struct {
	gorm.Model
	Email       string `gorm:"unique"`
	Password    string `gorm:"not null"`
	Username    string `gorm:"not null"`
	Firstname   string `gorm:"not null"`
	Lastname    string `gorm:"not null"`
	Colocations []Colocation
}

func GetUserByEmail(email string) (User, error) {
	db := GetConnection()
	var user User
	err := db.First(&user, "email = ?", email).Error
	return user, err
}

type Colocation struct {
	gorm.Model
	Name   string `gorm:"not null"`
	UserID uint   `gorm:"not null"`
}

type ColocMember struct {
	gorm.Model
	UserID       uint    `gorm:"not null"`
	ColocationID uint    `gorm:"not null"`
	Score        float32 `gorm:"not null"`
}

type Chat struct {
	gorm.Model
	ColocationID uint `gorm:"not null"`
	Messages     []Message
}

type Message struct {
	gorm.Model
	UserID       uint `gorm:"not null"`
	ColocationID uint `gorm:"not null"`
	ChatID       uint `gorm:"not null"`
}

type Service struct {
	gorm.Model
	Title        string  `gorm:"not null"`
	Author       string  `gorm:"not null"`
	Desc         string  `gorm:"not null"`
	Cost         float32 `gorm:"not null"`
	ColocationID uint    `gorm:"not null"`
}

type AchievedService struct {
	gorm.Model
	Title        string  `gorm:"not null"`
	Desc         string  `gorm:"not null"`
	Cost         float32 `gorm:"not null"`
	ColocationID uint    `gorm:"not null"`
}
