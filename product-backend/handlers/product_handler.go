package handlers

import (
	"context"
	"product-backend/models"
	"product-backend/services"
	pb "product-backend/grpc"
)

type ProductHandler struct {
	pb.UnimplementedProductServiceServer
	productService *services.ProductService
}

func NewProductHandler(productService *services.ProductService) *ProductHandler {
	return &ProductHandler{productService: productService}
}

func (h *ProductHandler) CreateProduct(ctx context.Context, req *pb.CreateProductRequest) (*pb.ProductResponse, error) {
	product := models.Product{
		Name:     req.Name,
		Price:    float64(req.Price),
		Quantity: int(req.Quantity),
	}
	if err := h.productService.CreateProduct(&product); err != nil {
		return nil, err
	}
	return &pb.ProductResponse{
		Id:       int32(product.ID),
		Name:     product.Name,
		Price:    float32(product.Price),
		Quantity: int32(product.Quantity),
	}, nil
}

func (h *ProductHandler) GetProduct(ctx context.Context, req *pb.GetProductRequest) (*pb.ProductResponse, error) {
	product, err := h.productService.GetProduct(int(req.Id))
	if err != nil {
		return nil, err
	}
	return &pb.ProductResponse{
		Id:       int32(product.ID),
		Name:     product.Name,
		Price:    float32(product.Price),
		Quantity: int32(product.Quantity),
	}, nil
}

func (h *ProductHandler) UpdateProduct(ctx context.Context, req *pb.UpdateProductRequest) (*pb.ProductResponse, error) {
	product := models.Product{
		ID:       int(req.Id),
		Name:     req.Name,
		Price:    float64(req.Price),
		Quantity: int(req.Quantity),
	}
	if err := h.productService.UpdateProduct(&product); err != nil {
		return nil, err
	}
	return &pb.ProductResponse{
		Id:       int32(product.ID),
		Name:     product.Name,
		Price:    float32(product.Price),
		Quantity: int32(product.Quantity),
	}, nil
}

func (h *ProductHandler) DeleteProduct(ctx context.Context, req *pb.DeleteProductRequest) (*pb.DeleteProductResponse, error) {
	if err := h.productService.DeleteProduct(int(req.Id)); err != nil {
		return nil, err
	}
	return &pb.DeleteProductResponse{Success: true}, nil
}

func (h *ProductHandler) ListProducts(ctx context.Context, req *pb.ListProductsRequest) (*pb.ListProductsResponse, error) {
	products, err := h.productService.ListProducts()
	if err != nil {
		return nil, err
	}
	var productResponses []*pb.ProductResponse
	for _, p := range products {
		productResponses = append(productResponses, &pb.ProductResponse{
			Id:       int32(p.ID),
			Name:     p.Name,
			Price:    float32(p.Price),
			Quantity: int32(p.Quantity),
		})
	}
	return &pb.ListProductsResponse{Products: productResponses}, nil
}