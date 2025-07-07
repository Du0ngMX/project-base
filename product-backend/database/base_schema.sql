-- Drop tables if they exist
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DOUBLE PRECISION NOT NULL,
    quantity INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Insert sample data into users table
INSERT INTO users (username, password) VALUES
('admin', '$2a$10$DwS3yy9KJZQQt7CODtCdv.p24/XfOZwN.NZz1ROeyVNUInc96siya'), -- Password: admin123
('user1', '$2a$10$JhNwS9HYJ2EcbSX37vHVeONO7XtgyuNsGCBZ21SqrWqJOd/W9Nlg6'); -- Password: user123

-- Insert sample data into products table
INSERT INTO products (name, price, quantity) VALUES
('Laptop', 999.99, 10),
('Smartphone', 499.99, 20),
('Headphones', 79.99, 50);