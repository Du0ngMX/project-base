package utils

import (
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func NewError(code codes.Code, message string) error {
	return status.Errorf(code, message)
}