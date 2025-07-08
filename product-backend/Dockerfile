# Stage 1: Build the Go application
FROM golang:1.18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy go.mod and go.sum to cache dependencies
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go binary
RUN CGO_ENABLED=0 GOOS=linux go build -o product-backend ./main.go

# Stage 2: Create a lightweight runtime image
FROM alpine:latest

# Install ca-certificates for HTTPS (if needed)
RUN apk --no-cache add ca-certificates

# Set working directory
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/product-backend .

# Expose port 8080 for the RESTful API
EXPOSE 8080

# Set environment variables (can be overridden at runtime)
ENV DB_HOST=postgres
ENV DB_USER=postgres
ENV DB_PASSWORD=your_password
ENV DB_NAME=mydb
ENV DB_PORT=5432

# Run the application
CMD ["./product-backend"]