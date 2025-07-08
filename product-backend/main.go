package main

import (
	"fmt"
	"log"
	"product-backend/config"
	"product-backend/handlers"
	"product-backend/middleware"
	"product-backend/repository"
	"product-backend/services"

	"github.com/gin-gonic/gin"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	// Load configuration
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	// Connect to PostgreSQL
	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable",
		cfg.DBHost, cfg.DBUser, cfg.DBPassword, cfg.DBName, cfg.DBPort)
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Initialize repositories
	userRepo := repository.NewUserRepository(db)
	productRepo := repository.NewProductRepository(db)

	// Initialize services
	authService := services.NewAuthService(userRepo)
	productService := services.NewProductService(productRepo)

	productHandler := handlers.NewProductHandler(productService)
	authHandler := handlers.NewAuthHandler(authService)

	// Initialize Gin router
	router := gin.Default()
	err = router.SetTrustedProxies([]string{"127.0.0.1"})
	// err = router.SetTrustedProxies(nil) // Trust all proxies (disable warning)
	if err != nil {
		log.Fatalf("Failed to set trusted proxies: %v", err)
	}

	// Register RESTful routes (handlers will be updated as needed)
	productRoutes := router.Group("/products", middleware.JWTAuth())
	{
		productRoutes.POST("/", productHandler.CreateProduct)
		productRoutes.GET("/", productHandler.ListProducts)
		productRoutes.GET(":id", productHandler.GetProduct)
		productRoutes.PUT(":id", productHandler.UpdateProduct)
		productRoutes.DELETE(":id", productHandler.DeleteProduct)
	}

	router.POST("/login", authHandler.Login)

	// Run HTTP server on port 8080
	router.Run(":8080")
}