CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT,
    correo VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE productos (
    codigo INT NOT NULL primary key,
    nombre VARCHAR(100) NOT NULL,
    stock int not null ,
    valor_unitario NUMERIC(10, 2) NOT NULL 
);

drop table pedidos;
CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,  
    fecha DATE NOT NULL,   
    cantidad INT NOT NULL,  
    valor_total NUMERIC(10, 2) NOT NULL,  
    codigo INT NOT NULL,    
    id_cliente serial NOT NULL,
    FOREIGN KEY (codigo) REFERENCES productos(codigo),  
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)  
);
-- Hacer antes del begin
ALTER SEQUENCE taller1.clientes_id_seq
	RESTART 1;
ALTER SEQUENCE taller1.pedidos_id_pedido_seq
	RESTART 1;


rollback; 

BEGIN;

INSERT INTO clientes (nombre, edad, correo) 
VALUES 
    ('Ana Gómez', 28, 'ana.gomez@gmail.com'),
    ('Luis Rodríguez', 34, 'luis.rodriguez@gmail.com'),
    ('Maria Fernández', 25, 'maria.fernandez@gmail.com');

   select * from clientes;

INSERT INTO productos (codigo, nombre, stock, valor_unitario) 
VALUES 
    (101, 'Mouse', 100, 25.50),
    (102, 'Teclado', 150, 45.75),
    (103, 'Monitor', 50, 150.00);


INSERT INTO pedidos (fecha, cantidad, valor_total, codigo, id_cliente) 
VALUES 
    ('2024-08-21', 1, 25.50, 101, 1),
    ('2024-08-22', 2, 91.50, 102, 2),
    ('2024-08-23', 1, 150.00, 103, 3);

   
UPDATE pedidos 
SET cantidad = 2 
WHERE id_pedido = 1;

UPDATE pedidos 
SET valor_total = 300.00 
WHERE id_pedido = 2;

UPDATE clientes 
SET edad = 29 
WHERE id = 1;

UPDATE clientes 
SET nombre = 'Andres Lopez'
WHERE id = '2';

UPDATE productos 
SET stock = 95 
WHERE codigo = 101;

UPDATE productos 
SET valor_unitario = 50.00 
WHERE codigo = 102;

DELETE FROM pedidos 
WHERE id_pedido = 1;

select * from pedidos;

DELETE FROM clientes 
WHERE id = 1;

DELETE FROM productos 
WHERE codigo = 101;
rollback;

COMMIT;




