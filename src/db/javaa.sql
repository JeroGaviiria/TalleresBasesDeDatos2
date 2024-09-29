CREATE TABLE javaa.clientes (
    identificacion INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INTEGER,
    correo VARCHAR(100)
);

CREATE TABLE javaa.productos (
    codigo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    stock INTEGER NOT NULL,
    valor_unitario NUMERIC(10, 2) NOT NULL
);

CREATE TABLE javaa.facturas (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    cantidad INTEGER NOT NULL,
    valor_total NUMERIC(15, 2) NOT NULL,
    pedido_estado VARCHAR(20) NOT NULL CHECK (pedido_estado IN ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO')),
    producto_id INTEGER REFERENCES javaa.productos(codigo),
    cliente_id INTEGER REFERENCES javaa.clientes(identificacion)
);

CREATE TABLE javaa.auditoria (
    fecha_inicio DATE,
    fecha_final DATE,
    factura_id INTEGER REFERENCES javaa.facturas(id),
    pedido_estado VARCHAR(20) CHECK (pedido_estado IN ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO'))
);


INSERT INTO javaa.productos (nombre, stock, valor_unitario)
VALUES
('Producto 1', 10, 100.00),
('Producto 2', 20, 150.00);

INSERT INTO javaa.clientes (identificacion, nombre, edad, correo)
VALUES (1, 'Cliente 1', 30, 'cliente1@example.com');

INSERT INTO javaa.facturas (fecha, cantidad, valor_total, pedido_estado, producto_id, cliente_id)
VALUES
('2024-01-15', 2, 200.00, 'PENDIENTE', 1, 1),
('2024-03-10', 1, 150.00, 'ENTREGADO', 2, 1),
('2024-05-20', 3, 300.00, 'BLOQUEADO', 1, 1);

-- Procedimiento almacenado
CREATE OR REPLACE PROCEDURE javaa.generar_auditoria(fecha_inicio DATE, fecha_final DATE)
LANGUAGE plpgsql
AS $$
DECLARE
    v_factura_id INTEGER;
    v_fecha DATE;
    v_pedido_estado VARCHAR(20);
BEGIN
    FOR v_factura_id, v_fecha, v_pedido_estado IN 
        SELECT id, fecha, pedido_estado FROM javaa.facturas
        WHERE fecha BETWEEN fecha_inicio AND fecha_final
    LOOP
        INSERT INTO javaa.auditoria (fecha_inicio, fecha_final, factura_id, pedido_estado)
        VALUES (fecha_inicio, fecha_final, v_factura_id, v_pedido_estado);
    END LOOP;
END;
$$;

select * from javaa.auditoria;


CREATE OR REPLACE PROCEDURE javaa.simular_ventas_mes()
LANGUAGE plpgsql
AS $$
DECLARE
    v_dia INTEGER := 30;  
    v_dia_actual INTEGER := 1;  
    v_fecha DATE;
    v_identificacion INTEGER;
    v_codigo_producto INTEGER;
    v_cantidad INTEGER;
    v_valor_unitario NUMERIC(10, 2);
    v_valor_total NUMERIC(15, 2);
    v_pedido_estado VARCHAR(20) := 'PENDIENTE'; 
BEGIN
    WHILE v_dia_actual <= v_dia LOOP
        v_fecha := CURRENT_DATE - (v_dia - v_dia_actual) * INTERVAL '1 day';

        FOR v_identificacion IN 
            SELECT identificacion 
            FROM javaa.clientes
        LOOP
            SELECT codigo, valor_unitario INTO v_codigo_producto, v_valor_unitario
            FROM javaa.productos
            ORDER BY RANDOM() LIMIT 1;
                   
            v_cantidad := FLOOR(RANDOM() * 10) + 1;                       
            v_valor_total := v_cantidad * v_valor_unitario;
                       
            INSERT INTO javaa.facturas (fecha, cantidad, valor_total, pedido_estado, producto_id, cliente_id) 
            VALUES (v_fecha, v_cantidad, v_valor_total, v_pedido_estado, v_codigo_producto, v_identificacion);
        END LOOP;
        
        v_dia_actual := v_dia_actual + 1;
    END LOOP;
END;
$$;
select * from javaa.facturas;
