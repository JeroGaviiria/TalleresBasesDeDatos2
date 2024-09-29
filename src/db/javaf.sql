CREATE TABLE javaf.cliente (
    identificacion INTEGER PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    direccion VARCHAR NOT NULL,
    telefono INTEGER NOT NULL
);

CREATE TABLE javaf.servicios (
    codigo SERIAL PRIMARY KEY,
    tipo VARCHAR NOT NULL,
    monto NUMERIC,
    cuota NUMERIC,
    estado VARCHAR NOT NULL CHECK (estado IN ('pago', 'no_pago', 'pendiente_pago')),
    intereses NUMERIC,
    valor_total NUMERIC,
    cliente_id INTEGER REFERENCES javaf.cliente(identificacion)
);

CREATE TABLE javaf.pagos (
    codigo_transaccion SERIAL PRIMARY KEY,
    fecha_pago DATE,
    total NUMERIC,
    servicio_id INTEGER REFERENCES javaf.servicios(codigo)
);


CREATE OR REPLACE PROCEDURE javaf.poblar_bd_simplificado()
LANGUAGE plpgsql
AS $$
DECLARE
    i INTEGER;
    cliente_id INTEGER;
BEGIN
    -- Insertar 50 clientes
    FOR i IN 1..50 LOOP
        INSERT INTO javaf.cliente (identificacion, nombre, email, direccion, telefono)
        VALUES (
            i,
            'Cliente ' || i,
            'cliente' || i || '@example.com',
            'Direccion ' || i,
            (random() * 9000000 + 6000000)::INT
        )
        RETURNING identificacion INTO cliente_id;

        INSERT INTO javaf.servicios (tipo, monto, cuota, estado, intereses, valor_total, cliente_id)
        VALUES
            ('agua', (random() * 100 + 50), (random() * 10 + 1), 'pendiente_pago', (random() * 10 + 1), (random() * 200 + 100), cliente_id),
            ('gas', (random() * 100 + 50), (random() * 10 + 1), 'pendiente_pago', (random() * 10 + 1), (random() * 200 + 100), cliente_id),
            ('luz', (random() * 100 + 50), (random() * 10 + 1), 'pendiente_pago', (random() * 10 + 1), (random() * 200 + 100), cliente_id);
    END LOOP;

    -- Insertar 50 pagos aleatorios a los servicios
    FOR i IN 1..50 LOOP
        INSERT INTO javaf.pagos (fecha_pago, total, servicio_id)
        VALUES (
            CURRENT_DATE - (random() * 30)::INT,  -- Fecha de pago aleatoria en los últimos 30 días
            (random() * 150 + 50),  -- Pago entre 50 y 200
            (SELECT codigo FROM javaf.servicios ORDER BY random() LIMIT 1)  -- Servicio aleatorio
        );
    END LOOP;
END $$;


CREATE OR REPLACE FUNCTION javaf.transacciones_total_mes(p_mes INTEGER, p_cliente_id INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    v_total NUMERIC := 0;
    r_pago RECORD;
BEGIN
    RAISE NOTICE 'Número de cliente: %', p_cliente_id;
  
    FOR r_pago IN
        SELECT p.total
        FROM javaf.pagos p
        JOIN javaf.servicios s ON p.servicio_id = s.codigo
        WHERE s.cliente_id = p_cliente_id
          AND EXTRACT(MONTH FROM p.fecha_pago) = p_mes
    LOOP 
     
        v_total := v_total + r_pago.total;
    END LOOP;

    RETURN v_total;
END $$ LANGUAGE plpgsql;

SELECT * FROM javaf.cliente;
SELECT * FROM javaf.servicios;
SELECT * FROM javaf.pagos;


