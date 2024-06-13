package db

import (
	"Colibris/models"
	"fmt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"log"
	"os"
	"sync"
)

var dbInstance *gorm.DB
var once sync.Once

func Connect() *gorm.DB {
	once.Do(func() {
		dsn := os.Getenv("DB_URL")
		var err error
		dbInstance, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
		if err != nil {
			log.Fatalf("Failed to connect to database: %v", err)
		}
	})
	return dbInstance
}

func Migrate(db *gorm.DB) {
	err := db.AutoMigrate(
		&models.User{},
		&models.Colocation{},
		&models.ColocMember{},
		&models.ResetPassword{},
		&models.Invitation{},
	)
	if err != nil {
		log.Fatalf("Failed to migrate database: %v", err)
	}
	fmt.Println("Database migration completed successfully.")
}

//
//type User struct {
//	gorm.Model
//	Email       string       `gorm:"unique"`
//	Password    string       `gorm:"not null"`
//	Username    string       `gorm:"not null"`
//	Firstname   string       `gorm:"not null"`
//	Lastname    string       `gorm:"not null"`
//	Colocations []Colocation `gorm:"foreignkey:UserID"`
//}
//
//type Colocation struct {
//	gorm.Model
//	Name   string `gorm:"not null"`
//	UserID uint
//}
//
//type ColocMember struct {
//	gorm.Model
//	UserID       uint    `gorm:"not null"`
//	ColocationID uint    `gorm:"not null"`
//	Score        float32 `gorm:"not null"`
//}
//
//type Chat struct {
//	gorm.Model
//	ColocationID uint `gorm:"not null"`
//	Messages     []Message
//}
//
//type Message struct {
//	gorm.Model
//	UserID       uint `gorm:"not null"`
//	ColocationID uint `gorm:"not null"`
//	ChatID       uint `gorm:"not null"`
//}
//
//type Service struct {
//	gorm.Model
//	Title        string  `gorm:"not null"`
//	Author       string  `gorm:"not null"`
//	Desc         string  `gorm:"not null"`
//	Cost         float32 `gorm:"not null"`
//	ColocationID uint    `gorm:"not null"`
//}
//
//type AchievedService struct {
//	gorm.Model
//	Title        string  `gorm:"not null"`
//	Desc         string  `gorm:"not null"`
//	Cost         float32 `gorm:"not null"`
//	ColocationID uint    `gorm:"not null"`
//}
