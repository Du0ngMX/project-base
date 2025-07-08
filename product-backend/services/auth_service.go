package services

import (
	"errors"
	"product-backend/models"
	"product-backend/repository"
	"product-backend/utils"
	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	userRepo *repository.UserRepository
}

func NewAuthService(userRepo *repository.UserRepository) *AuthService {
	return &AuthService{userRepo: userRepo}
}

func (s *AuthService) Login(username, password string) (string, error) {
	user, err := s.userRepo.FindByUsername(username)
	if err != nil {
		return "", errors.New("invalid username or password")
	}

	// Check password
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return "", errors.New("invalid username or password")
	}

	// Generate JWT token
	token, err := utils.GenerateJWT(int(user.ID))
	if err != nil {
		return "", err
	}

	return token, nil
}

// CreateDefaultUser creates a sample user using models.User and supports data initialization
func (s *AuthService) CreateDefaultUser(username, password string) error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	user := models.User{
		Username: username,
		Password: string(hashedPassword),
	}

	return s.userRepo.Create(&user)
}