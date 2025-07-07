package services

import (
	"product-backend/models"
	"product-backend/repository"
)

type ProductService struct {
	productRepo *repository.ProductRepository
}

func NewProductService(productRepo *repository.ProductRepository) *ProductService {
	return &ProductService{productRepo: productRepo}
}

func (s *ProductService) CreateProduct(product *models.Product) error {
	return s.productRepo.Create(product)
}

func (s *ProductService) GetProduct(id int) (*models.Product, error) {
	return s.productRepo.GetByID(id)
}

func (s *ProductService) UpdateProduct(product *models.Product) error {
	return s.productRepo.Update(product)
}

func (s *ProductService) DeleteProduct(id int) error {
	return s.productRepo.Delete(id)
}

func (s *ProductService) ListProducts() ([]models.Product, error) {
	return s.productRepo.List()
}