create table cliente (
	identificacion integer primary key,
	nombre varchar not null,
	email varchar not null,
	direccion varchar not null,
	telefono integer not null
);

create table servicios (
	codigo serial primary key,
	tipo varchar not null,
	monto numeric,
	cuota numeric,
	estado varchar not null check (estado IN ('pago', 'no_pago', 'pendiente_pago')),
	intereses numeric,
	valor_total numeric,
	cliente_id integer references cliente(identificacion)
);

create table pagos (
	codigo_transaccion serial primary key,
	fecha_pago date,
	total numeric,
	servicio_id integer references servicios(codigo)
);

CREATE OR REPLACE PROCEDURE poblar_bd_simplificado()
LANGUAGE plpgsql
AS $$
DECLARE
    i INTEGER;
    cliente_id INTEGER;
BEGIN
    -- Inserta 50 clientes
    FOR i IN 1..50 LOOP
        INSERT INTO cliente (identificacion, nombre, email, direccion, telefono)
        VALUES (
            i,
            'Cliente ' || i,
            'cliente' || i || '@example.com',
            'Direccion ' || i,
            (random() * 9000000 + 6000000)::INT
        )
        RETURNING identificacion INTO cliente_id;

        INSERT INTO servicios (tipo, monto, cuota, estado, intereses, valor_total, cliente_id)
        VALUES
            ('agua', (random() * 100 + 50), (random() * 10 + 1), 'pendiente_pago', (random() * 10 + 1), (random() * 200 + 100), cliente_id),
            ('gas', (random() * 100 + 50), (random() * 10 + 1), 'pendiente_pago', (random() * 10 + 1), (random() * 200 + 100), cliente_id),
            ('luz', (random() * 100 + 50), (random() * 10 + 1), 'pendiente_pago', (random() * 10 + 1), (random() * 200 + 100), cliente_id);
    END LOOP;

    -- Inserta 50 pagos aleatorios a los servicios
    FOR i IN 1..50 LOOP
        INSERT INTO pagos (fecha_pago, total, servicio_id)
        VALUES (
            CURRENT_DATE - (random() * 30)::INT,  -- Pone una fecha de pago aleatoria en los últimos 30 días
            (random() * 150 + 50),  -- Pago entre 50 y 200
            (SELECT codigo FROM servicios ORDER BY random() LIMIT 1)  -- Servicio aleatorio
        );
    END LOOP;
END $$;


CREATE OR REPLACE FUNCTION transacciones_total_mes(p_mes INTEGER, p_cliente_id INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    v_total NUMERIC := 0;
    r_pago RECORD;
BEGIN
    -- Muestra el número del cliente
    RAISE NOTICE 'Número de cliente: %', p_cliente_id;

    -- Itera sobre los pagos del cliente y el mes seleccionado
    FOR r_pago IN
        SELECT p.total
        FROM pagos p
        JOIN servicios s ON p.servicio_id = s.codigo
        WHERE s.cliente_id = p_cliente_id
          AND EXTRACT(MONTH FROM p.fecha_pago) = p_mes
    LOOP 
        -- Sumar el total de cada pago al total acumulado
        v_total := v_total + r_pago.total;
    END LOOP;

    RETURN v_total;
end $$ language plpgsql;

call poblar_bd_simplificado();
select transacciones_total_mes(7, 12);

 