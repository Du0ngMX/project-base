// package utils

// import (
// 	"github.com/golang-jwt/jwt/v5"
// 	"os"
// )

// func ValidateToken(tokenStr string) (*jwt.Token, error) {
// 	return jwt.Parse(tokenStr, func(token *jwt.Token) (interface{}, error) {
// 		return []byte(os.Getenv("JWT_SECRET")), nil
// 	})
// }

package utils

import (
	"time"
	"product-backend/config"
	"github.com/dgrijalva/jwt-go"
)

type Claims struct {
	UserID int `json:"user_id"`
	jwt.StandardClaims
}

func GenerateJWT(userID int) (string, error) {
	cfg, _ := config.LoadConfig()
	claims := &Claims{
		UserID: userID,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Add(24 * time.Hour).Unix(),
			IssuedAt:  time.Now().Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(cfg.JWTSecret))
}

func ValidateJWT(tokenString string) (*Claims, error) {
	cfg, _ := config.LoadConfig()
	claims := &Claims{}
	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		return []byte(cfg.JWTSecret), nil
	})
	if err != nil {
		return nil, err
	}
	if !token.Valid {
		return nil, jwt.ErrSignatureInvalid
	}
	return claims, nil
}