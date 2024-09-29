CREATE TABLE javaf2.cliente (
    identificacion INTEGER PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    direccion VARCHAR NOT NULL,
    telefono INTEGER NOT NULL
);

CREATE TABLE javaf2.servicios (
    codigo SERIAL PRIMARY KEY,
    mes INTEGER NOT NULL,
    tipo VARCHAR NOT NULL,
    monto NUMERIC NOT NULL,
    cuota NUMERIC,
    intereses NUMERIC,
    valor_total NUMERIC,
    estado VARCHAR NOT NULL CHECK (estado IN ('pago', 'no_pago', 'pendiente_pago')),
    cliente_id INTEGER REFERENCES javaf2.cliente(identificacion)
);

CREATE TABLE javaf2.pagos (
    codigo_transaccion SERIAL PRIMARY KEY,
    fecha_pago DATE,
    estado VARCHAR NOT NULL CHECK (estado IN ('pago', 'no_pago')),
    servicio_id INTEGER REFERENCES javaf2.servicios(codigo)
);

-- Población de la tabla cliente
INSERT INTO javaf2.cliente (identificacion, nombre, email, direccion, telefono) VALUES
(1, 'Cliente 1', 'cliente1@example.com', 'Direccion 1', 1234567890),
(2, 'Cliente 2', 'cliente2@example.com', 'Direccion 2', 1234567891),
(3, 'Cliente 3', 'cliente3@example.com', 'Direccion 3', 1234567892);

INSERT INTO javaf2.servicios (mes, tipo, monto, cuota, intereses, valor_total, estado, cliente_id) VALUES
(9, 'agua', 100.00, 10.00, 5.00, 105.00, 'no_pago', 1),
(9, 'gas', 80.00, 8.00, 4.00, 84.00, 'no_pago', 1),
(9, 'luz', 120.00, 12.00, 6.00, 126.00, 'pago', 2),
(9, 'agua', 90.00, 9.00, 4.50, 94.50, 'no_pago', 3),
(10, 'gas', 70.00, 7.00, 3.50, 73.50, 'no_pago', 3);

INSERT INTO javaf2.pagos (fecha_pago, estado, servicio_id) VALUES
(CURRENT_DATE - 5, 'pago', 3);  


CREATE OR REPLACE FUNCTION javaf2.servicios_no_pagados_mes(p_mes INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    v_total NUMERIC := 0;
    v_cliente_id INTEGER;
    v_monto NUMERIC;
BEGIN
    FOR v_cliente_id IN
        SELECT identificacion FROM javaf2.cliente
    LOOP
        SELECT COALESCE(SUM(monto), 0) INTO v_monto
        FROM javaf2.servicios
        WHERE cliente_id = v_cliente_id AND mes = p_mes AND estado = 'no_pago';

        v_total := v_total + v_monto;
    END LOOP;

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;


