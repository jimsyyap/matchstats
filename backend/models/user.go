package models

import (
    "golang.org/x/crypto/bcrypt"
    "gorm.io/gorm"
    "database/sql"
    "log"
)

// User represents a user in the database
type User struct {
    ID           uint   `gorm:"primaryKey"`
    Email        string `gorm:"unique;not null"`
    PasswordHash string `gorm:"not null"`
    Name         string
    Role         string `gorm:"default:player"`
    CreatedAt    int64
    UpdatedAt    int64
    LastLogin    int64
    IsActive     bool `gorm:"default:true"`
}

func (u *User) BeforeCreate(tx *gorm.DB) (err error) {
    u.CreatedAt = time.Now().Unix()
    u.UpdatedAt = time.Now().Unix()
    return
}

// CreateUser inserts a new user into the database
func CreateUser(db *sql.DB, email, password, name, role string) error {
    hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
    if err != nil {
        return err
    }

    query := `INSERT INTO users (email, password_hash, name, role) VALUES ($1, $2, $3, $4)`
    _, err = db.Exec(query, email, string(hashedPassword), name, role)
    return err
}

// GetUserByEmail retrieves a user by email
func GetUserByEmail(db *sql.DB, email string) (*User, error) {
    var user User
    query := `SELECT id, email, password_hash, name, role FROM users WHERE email = $1`
    err := db.QueryRow(query, email).Scan(&user.ID, &user.Email, &user.PasswordHash, &user.Name, &user.Role)
    if err != nil {
        if err == sql.ErrNoRows {
            return nil, nil
        }
        log.Println("Error querying user:", err)
        return nil, err
    }
    return &user, nil
}
