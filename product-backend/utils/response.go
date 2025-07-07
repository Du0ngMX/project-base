// package utils

// import (
// 	"net/http"
// 	"github.com/gin-gonic/gin"
// )

// func JSONError(c *gin.Context, status int, message string) {
// 	c.JSON(status, gin.H{"error": message})
// }

package utils

import (
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func NewError(code codes.Code, message string) error {
	return status.Errorf(code, message)
}