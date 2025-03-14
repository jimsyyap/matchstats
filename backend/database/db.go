// database/db.go
package database

import (
    "fmt"
    "log"
    "os"

    "github.com/joho/godotenv"
    "gorm.io/driver/postgres"
    "gorm.io/gorm"
)

var DB *gorm.DB

func InitDB() {
    // Load environment variables
    err := godotenv.Load()
    if err != nil {
        log.Fatal("Error loading .env file")
    }

    // Build connection string
    dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
        os.Getenv("DB_HOST"),
        os.Getenv("DB_PORT"),
        os.Getenv("DB_USER"),
        os.Getenv("DB_PASSWORD"),
        os.Getenv("DB_NAME"),
    )

    // Connect to the database
    var errDB error
    DB, errDB = gorm.Open(postgres.Open(dsn), &gorm.Config{})
    if errDB != nil {
        log.Fatalf("Failed to connect to the database: %v", errDB)
    }

    fmt.Println("Database connected successfully!")
}
