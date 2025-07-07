package models

import "gorm.io/gorm"

type Product struct {
	gorm.Model
	ID       int     `gorm:"primaryKey"`
	Name     string  `gorm:"not null"`
	Price    float64 `gorm:"not null"`
	Quantity int     `gorm:"not null"`
}