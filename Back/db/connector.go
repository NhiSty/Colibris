package db

import (
	"Colibris/model"
	"fmt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
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

	err2 := db.Migrator().DropTable(
		&model.User{},
		&model.Colocation{},
		&model.ColocMember{},
		&model.ResetPassword{},
		&model.Invitation{},
		&model.Log{},
		&model.Task{},
		&model.Message{},
		&model.FeatureFlag{},
		&model.Vote{},
	)
	if err2 != nil {
		return
	}
	err := db.AutoMigrate(
		&model.User{},
		&model.Colocation{},
		&model.ColocMember{},
		&model.ResetPassword{},
		&model.Invitation{},
		&model.Log{},
		&model.Task{},
		&model.Vote{},
		&model.Message{},
		&model.FeatureFlag{},
	)

	seed(db)

	if err != nil {
		log.Fatalf("Failed to migrate database: %v", err)
	}
	fmt.Println("Database migration completed successfully.")
}

func seed(db *gorm.DB) {
	db.Clauses(clause.OnConflict{DoNothing: true}).Create(&model.User{
		Email: "admin@admin.com",
		// test123!
		Password:  "$2a$10$cFrne/rnK4JoEJn.bwdDJetpjbivABHtK/oy2/dYNjs6QUj7Fn0Pi",
		Firstname: "admin",
		Lastname:  "admin",
		Roles:     model.ROLE_ADMIN,
	})
	db.Clauses(clause.OnConflict{DoNothing: true}).Create(&model.User{
		Email: "esgi.user@yopmail.com",
		// test123!
		Password:  "$2a$10$cFrne/rnK4JoEJn.bwdDJetpjbivABHtK/oy2/dYNjs6QUj7Fn0Pi",
		Firstname: "demo",
		Lastname:  "esgi",
		Roles:     model.ROLE_USER,
	})
	db.Clauses(clause.OnConflict{DoNothing: true}).Create(&model.User{
		Email: "john9@yopmail.com",
		// test123!
		Password:  "$2a$10$cFrne/rnK4JoEJn.bwdDJetpjbivABHtK/oy2/dYNjs6QUj7Fn0Pi",
		Firstname: "Doe",
		Lastname:  "John",
		Roles:     model.ROLE_USER,
	})
	db.Clauses(clause.OnConflict{DoNothing: true}).Create(&model.User{
		Email: "james9@yopmail.com",
		// test123!
		Password:  "$2a$10$cFrne/rnK4JoEJn.bwdDJetpjbivABHtK/oy2/dYNjs6QUj7Fn0Pi",
		Firstname: "Bond",
		Lastname:  "james",
		Roles:     model.ROLE_USER,
	})

	db.Clauses(clause.OnConflict{DoNothing: true}).Create(&model.FeatureFlag{
		Name:  "maintenance",
		Value: false,
	})
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
