package handlers

import (
	"context"
	"product-backend/services"
	pb "product-backend/grpc"
)

type AuthHandler struct {
	pb.UnimplementedAuthServiceServer
	authService *services.AuthService
}

func NewAuthHandler(authService *services.AuthService) *AuthHandler {
	return &AuthHandler{authService: authService}
}

func (h *AuthHandler) Login(ctx context.Context, req *pb.LoginRequest) (*pb.LoginResponse, error) {
	token, err := h.authService.Login(req.Username, req.Password)
	if err != nil {
		return nil, err
	}
	return &pb.LoginResponse{Token: token}, nil
}