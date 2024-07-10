package db

import (
	"errors"
	"fmt"

	"github.com/acme-sky/acmebank-api/internal/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

// Global variable but private
var db *gorm.DB = nil

// Init the database from a DSN string which must be a valid PostgreSQL dsn.
// Also, auto migrate all the models.
func InitDb(dsn string) (*gorm.DB, error) {
	var err error
	db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err := db.Exec("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"").Error; err != nil {
		panic(fmt.Sprintf("failed to create extension: %v", err))
	}

	if err == nil {
		db.AutoMigrate(&models.Payment{})
	}

	return db, err
}

// Return the instance or error if the config is not laoded yet
func GetDb() (*gorm.DB, error) {
	if db == nil {
		return nil, errors.New("You must call `InitDb()` first.")
	}
	return db, nil
}
