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

CREATE OR REPLACE PROCEDURE calcular_stock_total()
language plpgsql
AS $$
DECLARE
    v_total_stock INTEGER := 0;
    v_stock_actual INTEGER;
    v_nombre_producto VARCHAR;
BEGIN
    FOR v_nombre_producto, v_stock_actual IN SELECT nombre_producto, stock FROM productos
    LOOP
        RAISE NOTICE 'El nombre del producto es: %', v_nombre_producto;
        RAISE NOTICE 'El stock actual del producto es: %', v_stock_actual;
        v_total_stock := v_total_stock + v_stock_actual; 
    END LOOP;
    RAISE NOTICE 'El stock total es de : %', v_total_stock;
end;
$$ language plpgsql;