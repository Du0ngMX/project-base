// package middleware

// import (
// 	"net/http"
// 	"os"
// 	"strings"

// 	"github.com/gin-gonic/gin"
// 	"github.com/golang-jwt/jwt/v5"
// )

// func JWTAuth() gin.HandlerFunc {
// 	return func(c *gin.Context) {
// 		authHeader := c.GetHeader("Authorization")
// 		if !strings.HasPrefix(authHeader, "Bearer ") {
// 			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Missing token"})
// 			return
// 		}
// 		tokenStr := strings.TrimPrefix(authHeader, "Bearer ")
// 		token, err := jwt.Parse(tokenStr, func(token *jwt.Token) (interface{}, error) {
// 			return []byte(os.Getenv("JWT_SECRET")), nil
// 		})
// 		if err != nil || !token.Valid {
// 			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
// 			return
// 		}
// 		c.Next()
// 	}
// }

package middleware

import (
	"context"
	"product-backend/utils"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

func JWTAuthInterceptor() grpc.UnaryServerInterceptor {
	return func(
		ctx context.Context,
		req interface{},
		info *grpc.UnaryServerInfo,
		handler grpc.UnaryHandler,
	) (interface{}, error) {
		// Skip authentication for Login endpoint
		if info.FullMethod == "/grpc.AuthService/Login" {
			return handler(ctx, req)
		}

		md, ok := metadata.FromIncomingContext(ctx)
		if !ok {
			return nil, status.Errorf(codes.Unauthenticated, "Missing metadata")
		}

		authHeader, ok := md["authorization"]
		if !ok || len(authHeader) == 0 {
			return nil, status.Errorf(codes.Unauthenticated, "Missing authorization header")
		}

		token := authHeader[0]
		if len(token) > 7 && token[:7] == "Bearer " {
			token = token[7:]
		}

		claims, err := utils.ValidateJWT(token)
		if err != nil {
			return nil, status.Errorf(codes.Unauthenticated, "Invalid token: %v", err)
		}

		ctx = context.WithValue(ctx, "user_id", claims.UserID)
		return handler(ctx, req)
	}
}