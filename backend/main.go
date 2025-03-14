// main.go
package main

import (
    "backend/database"
    "backend/models"
)

func main() {
    database.InitDB()

    // Auto-migrate the User model
    database.DB.AutoMigrate(&models.User{})

    // Start the server...
}
