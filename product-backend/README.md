Product Backend RESTful Project
This project implements a RESTful API backend for managing products and user authentication using Go, PostgreSQL, GORM, and the Gin web framework. It includes endpoints for product CRUD operations and user login with JWT authentication.
Prerequisites
Before running the project, ensure you have the following installed:

Go (version 1.18 or higher): Download
PostgreSQL (version 12 or higher): Download
Postman (version 9.0 or higher, for testing RESTful APIs): Download
cURL (optional, for testing via CLI): Typically pre-installed on most systems

Project Structure
product-backend/
├── config/                           # Configuration loading (e.g., database settings)
├── database/                         # Database initialization
├── handlers/                         # RESTful handlers for Product and Auth endpoints
├── middleware/                       # Middleware for JWT authentication
├── models/                           # GORM models (User, Product)
├── repository/                       # Database operations
├── services/                         # Business logic for Product and Auth services
├── utils/                            # Utility functions (e.g., JWT generation)
├── go.mod                            # Go module dependencies
├── main.go                           # Main application entry point

Setup Instructions
1. Clone the Repository
git clone <repository-url>
cd product-backend

2. Initialize Go Module
Ensure the go.mod file exists with the following content:
module product-backend

go 1.18

require (
    github.com/dgrijalva/jwt-go v3.2.0+incompatible
    github.com/gin-gonic/gin v1.8.1
    golang.org/x/crypto v0.0.0-20221012134737-56aed0617322
    gorm.io/driver/postgres v1.4.0
    gorm.io/gorm v1.24.0
)

Run the following commands to sync dependencies:
go clean -modcache
go mod tidy
go mod vendor

3. Configure PostgreSQL

Install and start PostgreSQL on your machine.
Create a database (e.g., mydb):

psql -U postgres
CREATE DATABASE mydb;


Create tables for users and products. Save the following SQL to base_schema.sql:

-- Create table users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create table products
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DOUBLE PRECISION NOT NULL,
    quantity INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

Run the SQL:
psql -U postgres -d mydb -f base_schema.sql


Create a config/config.go file to load database configuration:

package config

import "os"

type Config struct {
    DBHost     string
    DBUser     string
    DBPassword string
    DBName     string
    DBPort     string
}

func LoadConfig() (*Config, error) {
    return &Config{
        DBHost:     os.Getenv("DB_HOST"),
        DBUser:     os.Getenv("DB_USER"),
        DBPassword: os.Getenv("DB_PASSWORD"),
        DBName:     os.Getenv("DB_NAME"),
        DBPort:     os.Getenv("DB_PORT"),
    }, nil
}


Set environment variables for database connection (Windows example):

set DB_HOST=localhost
set DB_USER=postgres
set DB_PASSWORD=your_password
set DB_NAME=mydb
set DB_PORT=5432

On Linux/MacOS:
export DB_HOST=localhost
export DB_USER=postgres
export DB_PASSWORD=your_password
export DB_NAME=mydb
export DB_PORT=5432

4. Run the Application
Start the RESTful server:
cd product-backend
go run main.go

The server will start on localhost:8080 and create sample data (users admin/admin123, user1/user123, and products Laptop, Smartphone, Headphones).
Verify the server is running by checking for the log: Gin server is running on port :8080.
5. Test RESTful Endpoints
Using Postman

Open Postman (version 9.0 or higher).
Create a new HTTP request:
POST /login: Authenticate and retrieve a JWT token.
URL: http://localhost:8080/login
Body (JSON):{
    "username": "admin",
    "password": "admin123"
}


Response (should return a JWT token):{
    "token": "your_jwt_token_here"
}




GET /products: List all products (requires JWT).
URL: http://localhost:8080/products
Headers: Authorization: Bearer your_jwt_token_here


POST /products: Create a new product (requires JWT).
URL: http://localhost:8080/products
Headers: Authorization: Bearer your_jwt_token_here
Body (JSON):{
    "name": "Tablet",
    "price": 299.99,
    "quantity": 50
}




GET /products/:id: Get a product by ID (requires JWT).
URL: http://localhost:8080/products/1
Headers: Authorization: Bearer your_jwt_token_here


PUT /products/:id: Update a product by ID (requires JWT).
URL: http://localhost:8080/products/1
Headers: Authorization: Bearer your_jwt_token_here
Body (JSON):{
    "name": "Updated Laptop",
    "price": 1299.99,
    "quantity": 30
}




DELETE /products/:id: Delete a product by ID (requires JWT).
URL: http://localhost:8080/products/1
Headers: Authorization: Bearer your_jwt_token_here





Using cURL (Optional)

Test the Login endpoint:

curl -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"admin","password":"admin123"}'


Test the ListProducts endpoint (replace your_jwt_token_here with the token from login):

curl -X GET http://localhost:8080/products -H "Authorization: Bearer your_jwt_token_here"

Troubleshooting
Database Connection Errors

Ensure PostgreSQL is running and environment variables (DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT) are set correctly.
Check tables:

psql -U postgres -d mydb -c "\dt"
psql -U postgres -d mydb -c "SELECT * FROM users;"
psql -U postgres -d mydb -c "SELECT * FROM products;"

JWT Authentication Errors

If you receive a 401 Unauthorized error, ensure the Authorization header is set with a valid JWT token (Bearer your_jwt_token_here).
Verify the token is not expired (check utils package for JWT expiration settings).

Duplicate Data

The CreateDefaultUser and CreateDefaultProduct functions in main.go check for existing entries to avoid UNIQUE constraint failed errors.

Notes

The project uses bcrypt for password hashing and jwt-go for authentication tokens.
Ensure the utils package contains a GenerateJWT function for token generation.
For production, consider securing the database connection with SSL and using environment variable files (e.g., .env) instead of setting variables manually.
The Gin server runs on localhost:8080 by default. Modify main.go to change the port if needed.
