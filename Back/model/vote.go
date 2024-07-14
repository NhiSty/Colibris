package model

type Vote struct {
	ID     uint `gorm:"primaryKey"`
	UserID uint `gorm:"not null"`
	TaskID uint `gorm:"not null"`
	Value  int  `gorm:"not null"`

	User User `gorm:"foreignKey:UserID" json:"-"`
	Task Task `gorm:"foreignKey:TaskID" json:"-"`
}
