CREATE TABLE taller16.factura (
    codigo_punto_venta INT PRIMARY KEY,
    descripcion JSONB NOT NULL
);

INSERT INTO taller16.categoria (nombre) VALUES
('categoría1');

SELECT 
    codigo_punto_venta,
    descripcion->>'nombre_cliente' AS nombre_cliente,
    descripcion->>'identificacion' AS identificacion,
    descripcion->>'direccion_cliente' AS direccion_cliente,
    descripcion->>'codigo_factura' AS codigo_factura,
    descripcion->>'total' AS total,
    descripcion->>'descuento' AS descuento,
    descripcion->>'total_factura' AS total_factura,
    jsonb_array_elements(descripcion->'productos') AS producto
FROM 
    taller16.factura;


--1.
CREATE OR REPLACE PROCEDURE taller16.guardar_factura(
    p_codigo_punto_venta INT,
    p_descripcion JSONB
) AS $$
DECLARE
    total_factura NUMERIC;
    descuento NUMERIC;
BEGIN
    total_factura := (p_descripcion->>'total_factura')::NUMERIC;
    descuento := (p_descripcion->>'descuento')::NUMERIC;

    IF total_factura > 10000 THEN
        RAISE EXCEPTION 'El valor total de la factura no puede superar 10,000 dolares.';
    END IF;

    IF descuento > 50 THEN
        RAISE EXCEPTION 'El descuento maximo para una factura debe ser de 50 dolares.';
    END IF;
    INSERT INTO taller16.factura (codigo_punto_venta, descripcion)
    VALUES (p_codigo_punto_venta, p_descripcion);
END;
$$ LANGUAGE plpgsql;

--2.
CREATE OR REPLACE PROCEDURE taller16.actualizar_factura(
    p_codigo_punto_venta INT,
    p_nueva_descripcion JSONB
) AS $$
BEGIN
    UPDATE taller16.factura
    SET descripcion = p_nueva_descripcion
    WHERE codigo_punto_venta = p_codigo_punto_venta;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No se encontró una factura con el código de punto de venta %.', p_codigo_punto_venta;
    END IF;
END;
$$ LANGUAGE plpgsql;

--3.
CREATE OR REPLACE FUNCTION taller16.obtener_nombre_cliente(
    p_identificacion TEXT
) RETURNS TEXT AS $$
DECLARE
    nombre_cliente TEXT;
BEGIN
    SELECT p.descripcion->>'nombre_cliente' INTO nombre_cliente
    FROM taller16.factura p
    WHERE p.descripcion->>'identificacion' = p_identificacion
    LIMIT 1;

    IF nombre_cliente IS NULL THEN
        RAISE EXCEPTION 'No se encontró un cliente con la identificacion %.', p_identificacion;
    END IF;

    RETURN nombre_cliente;
END;
$$ LANGUAGE plpgsql;

--4.
CREATE OR REPLACE FUNCTION taller16.obtener_info_facturas()
RETURNS TABLE (
    cliente TEXT,
    identificacion TEXT,
    codigo_factura TEXT,
    total NUMERIC,
    descuento NUMERIC,
    total_factura NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        descripcion->>'nombre_cliente' AS cliente,
        descripcion->>'identificacion' AS identificacion,
        descripcion->>'codigo_factura' AS codigo_factura,
        (descripcion->>'total')::NUMERIC AS total,
        (descripcion->>'descuento')::NUMERIC AS descuento,
        (descripcion->>'total_factura')::NUMERIC AS total_factura
    FROM 
        taller16.factura;
END;
$$ LANGUAGE plpgsql;

--5.
CREATE OR REPLACE FUNCTION taller16.obtener_productos_por_factura(
    p_codigo_factura TEXT
) RETURNS TABLE (
    cantidad INT,
    valor NUMERIC,
    nombre_producto TEXT,
    descripcion_producto TEXT,
    precio NUMERIC,
    categorias JSONB 
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (producto->>'cantidad')::INT AS cantidad,
        (producto->>'valor')::NUMERIC AS valor,
        (producto->'producto'->>'nombre') AS nombre_producto,
        (producto->'producto'->>'descripcion') AS descripcion_producto,
        (producto->'producto'->>'precio')::NUMERIC AS precio,
        producto->'producto'->'categorias' AS categorias 
    FROM 
        taller16.factura
    CROSS JOIN LATERAL jsonb_array_elements(descripcion->'productos') AS producto
    WHERE 
        descripcion->>'codigo_factura' = p_codigo_factura;
END;
$$ LANGUAGE plpgsql;
