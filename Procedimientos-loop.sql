create table clientes (
    identificacion INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INTEGER,
    correo VARCHAR(100)
);

create table  productos (
    codigo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    stock INTEGER NOT NULL,
    valor_unitario NUMERIC(10, 2) NOT NULL
);

create table  facturas (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    cantidad INTEGER NOT NULL,
    valor_total NUMERIC(15, 2) NOT NULL,
    pedido_estado VARCHAR(20) NOT NULL CHECK (pedido_estado IN ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO')),
    producto_id INTEGER REFERENCES productos(codigo),
    cliente_id INTEGER REFERENCES clientes(identificacion)
);


CREATE TABLE auditoria (
    fecha_inicio DATE,
    fecha_final DATE,
    factura_id INTEGER REFERENCES facturas(id),
    pedido_estado VARCHAR(20) CHECK (pedido_estado IN ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO'))
);

-- Procedimiento Almacenado
CREATE OR REPLACE PROCEDURE generar_auditoria(fecha_inicio DATE, fecha_final DATE)
LANGUAGE plpgsql
AS $$
DECLARE
    v_factura_id INTEGER;
    v_fecha DATE;
    v_pedido_estado VARCHAR(20);
begin
    FOR v_factura_id, v_fecha, v_pedido_estado IN SELECT id, fecha, pedido_estado FROM facturas
    LOOP
        IF v_fecha >= fecha_inicio AND v_fecha <= fecha_final THEN
            INSERT INTO auditoria (fecha_inicio, fecha_final, factura_id, pedido_estado)
            VALUES (fecha_inicio, fecha_final, v_factura_id, v_pedido_estado);
        END IF;
    end LOOP;
end;
$$ LANGUAGE plpgsql;

-- Procedimiento almacenado ventas
CREATE OR REPLACE PROCEDURE simular_ventas_mes()
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
     
        v_fecha := (CURRENT_DATE - EXTRACT(DAY FROM CURRENT_DATE) + v_dia_actual);

        FOR v_identificacion IN 
            SELECT identificacion 
            FROM clientes
        LOOP
            SELECT codigo, valor_unitario INTO v_codigo_producto, v_valor_unitario
            FROM productos
            ORDER BY RANDOM() LIMIT 1;
                   
            v_cantidad := FLOOR(RANDOM() * 10) + 1;                       
            v_valor_total := v_cantidad * v_valor_unitario;
                       
            INSERT INTO facturas (fecha, cantidad, valor_total, pedido_estado, producto_id, cliente_id) VALUES (v_fecha, v_cantidad, v_valor_total, v_pedido_estado, v_codigo_producto, v_identificacion);
        	END LOOP;
        
        v_dia_actual := v_dia_actual + 1;
    END LOOP;
END;
$$;
