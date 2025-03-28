--table countries
CREATE TABLE countries (
    id_country serial PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
--table roles
CREATE TABLE roles (
    id_role SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
--table taxes
CREATE TABLE taxes (
    id_tax SERIAL PRIMARY KEY,
    percentage DECIMAL(5,2) NOT NULL
);
--table offers
CREATE TABLE offers (
    id_offer SERIAL PRIMARY KEY,
    status VARCHAR(20) NOT NULL
);
--table discounts
CREATE TABLE discounts (
    id_discount SERIAL PRIMARY KEY,
    status VARCHAR(20) NOT NULL,
    percentage DECIMAL(5,2) NOT NULL
);
--table payments
CREATE TABLE payments (
    id_payment SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL
);
--table customers
CREATE TABLE customers (
    email VARCHAR(100) PRIMARY KEY,
    id_country INTEGER NOT NULL,
    id_role INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INTEGER,
    password VARCHAR(100) NOT NULL,
    physical_address TEXT,
    FOREIGN KEY (id_country) REFERENCES countries(id_country),
    FOREIGN KEY (id_role) REFERENCES roles(id_role)
);
--table invoice_status
CREATE TABLE invoice_status (
    id_invoice_status SERIAL PRIMARY KEY,
    status VARCHAR(50) NOT NULL
);
--table products
CREATE TABLE products (
    id_product SERIAL PRIMARY KEY,
    id_discount INTEGER,
    id_offer INTEGER,
    id_tax INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    details TEXT,
    minimum_stock INTEGER NOT NULL,
    maximum_stock INTEGER NOT NULL,
    current_stock INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    price_with_tax DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_discount) REFERENCES discounts(id_discount),
    FOREIGN KEY (id_offer) REFERENCES offers(id_offer),
    FOREIGN KEY (id_tax) REFERENCES taxes(id_tax)
);
--table product_customers
CREATE TABLE products_customers (
    id_product INTEGER NOT NULL,
    id_customer VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_product, id_customer),
    FOREIGN KEY (id_product) REFERENCES products(id_product),
    FOREIGN KEY (id_customer) REFERENCES customers(email)
);
--table invoices
CREATE TABLE invoices (
    id_invoice SERIAL PRIMARY KEY,
    id_customer VARCHAR(100) NOT NULL,
    id_payment INTEGER NOT NULL,
    id_invoice_status INTEGER NOT NULL,
    date DATE NOT NULL,
    total_to_pay DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_customer) REFERENCES customers(email),
    FOREIGN KEY (id_payment) REFERENCES payments(id_payment),
    FOREIGN KEY (id_invoice_status) REFERENCES invoice_status(id_invoice_status)
);
--table orders
CREATE TABLE orders (
    id_order SERIAL PRIMARY KEY,
    id_invoice INTEGER NOT NULL,
    id_product INTEGER NOT NULL,
    detail TEXT,
    amount INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_invoice) REFERENCES invoices(id_invoice),
    FOREIGN KEY (id_product) REFERENCES products(id_product)
);
-- 1. Insertar países
INSERT INTO countries (name) VALUES 
('Estados Unidos'),
('México'),
('España');

-- 2. Insertar roles
INSERT INTO roles (name) VALUES 
('Administrador'),
('Cliente Regular'),
('Cliente Premium');

-- 3. Insertar clientes
INSERT INTO customers (email, id_country, id_role, name, age, password, physical_address) VALUES
('juan@gmail.com', 1, 2, 'Juan Pérez', 30, 'pass123', 'Calle Principal 123, Ciudad A'),
('maria@gmail.com', 2, 2, 'María García', 25, 'pass456', 'Avenida Central 456, Ciudad B'),
('carlos@gmail.com', 3, 3, 'Carlos López', 40, 'pass789', 'Plaza Mayor 789, Ciudad C');

-- 4. Insertar impuestos
INSERT INTO taxes (percentage) VALUES 
(10.00),
(15.00),
(20.00);

-- 5. Insertar ofertas
INSERT INTO offers (status) VALUES 
('Activa'),
('Inactiva'),
('Pendiente');

-- 6. Insertar descuentos
INSERT INTO discounts (status, percentage) VALUES 
('Vigente', 5.00),
('Expirado', 10.00),
('Vigente', 15.00);

-- 7. Insertar productos
INSERT INTO products (id_discount, id_offer, id_tax, name, details, minimum_stock, maximum_stock, current_stock, price, price_with_tax) VALUES
(1, 1, 1, 'Laptop', 'Laptop de última generación', 5, 50, 20, 1000.00, 1100.00),
(2, 2, 2, 'Teléfono', 'Smartphone avanzado', 10, 100, 50, 500.00, 575.00),
(3, 3, 3, 'Tablet', 'Tablet de 10 pulgadas', 8, 80, 30, 300.00, 360.00);

-- 8. Insertar relaciones productos-clientes
INSERT INTO products_customers (id_product, id_customer) VALUES
(1, 'juan@gmail.com'),
(2, 'maria@gmail.com'),
(3, 'carlos@gmail.com');

-- 9. Insertar estados de factura
INSERT INTO invoice_status (status) VALUES 
('Pagada'),
('Pendiente'),
('Cancelada');

-- 10. Insertar métodos de pago
INSERT INTO payments (type) VALUES 
('Tarjeta de Crédito'),
('Transferencia Bancaria'),
('PayPal');

-- Primero insertar las facturas
INSERT INTO invoices (id_customer, id_payment, id_invoice_status, date, total_to_pay) VALUES
('juan@gmail.com', 1, 1, '2023-01-15', 1100.00),
('maria@gmail.com', 2, 2, '2023-01-16', 575.00),
('carlos@gmail.com', 3, 3, '2023-01-17', 360.00);

-- Ahora puedes insertar las órdenes que referencian esas facturas
INSERT INTO orders (id_invoice, id_product, detail, amount, price) VALUES
(1, 1, 'Laptop con descuento', 1, 1000.00),
(2, 2, 'Teléfono urgente', 1, 500.00),
(3, 3, 'Tablet para regalo', 1, 300.00);

--borrar fisrt last user
DELETE FROM products_customers 
WHERE id_customer IN ('juan@gmail.com', 'carlos@gmail.com');

DELETE FROM orders 
WHERE id_invoice IN (
    SELECT id_invoice FROM invoices 
    WHERE id_customer IN ('juan@gmail.com', 'carlos@gmail.com')
);

DELETE FROM invoices 
WHERE id_customer IN ('juan@gmail.com', 'carlos@gmail.com');

DELETE FROM customers 
WHERE email IN ('juan@gmail.com', 'carlos@gmail.com');

--Actualizando datos
UPDATE customers
SET 
    name = 'Andres Valverde',
    age = 45,
    physical_address = 'Nueva Dirección 123, Ciudad Actualizada'
WHERE email = (
    SELECT email FROM customers 
    ORDER BY email DESC 
    LIMIT 1
);
UPDATE taxes
SET percentage = percentage + 5.00;

UPDATE products
SET price = price * 1.10;

UPDATE products p
SET price_with_tax = p.price * (1 + (t.percentage/100))
FROM taxes t
WHERE p.id_tax = t.id_tax;

SELECT * FROM products