CREATE TABLE tallercursores12.envios (
    id SERIAL PRIMARY KEY,
    fecha_envio DATE NOT NULL,
    destino VARCHAR(100) NOT NULL,
    observacion VARCHAR(255),
    estado VARCHAR(20) CHECK (estado IN ('pendiente', 'en_ruta', 'entregado'))
);

--Poblar bd
CREATE OR REPLACE PROCEDURE tallercursores12.poblar_envios() LANGUAGE plpgsql
AS $$
DECLARE
    v_destinos TEXT[] := ARRAY['Pereira', 'Bogota', 'Medellin'];
BEGIN
TRUNCATE TABLE tallercursores12.envios;
ALTER SEQUENCE tallercursores12.envios_id_seq
	RESTART 1;
    FOR i IN 1..50 LOOP
        INSERT INTO tallercursores12.envios (fecha_envio, destino, observacion, estado)
        VALUES (
            CURRENT_DATE - (RANDOM() * 30)::int, 
            v_destinos[FLOOR(RANDOM() * 3) + 1],
            NULL,                                  
            'pendiente'                          
        );
    END LOOP;
END;
$$;

CALL tallercursores12.poblar_envios();
select * from tallercursores12.envios;

-- Primera_fase_envio
CREATE OR REPLACE PROCEDURE tallercursores12.primera_fase_envio() LANGUAGE plpgsql
AS $$
DECLARE
    v_cursor CURSOR FOR SELECT id FROM tallercursores12.envios WHERE estado = 'pendiente';
    v_id INTEGER;
BEGIN
    OPEN v_cursor;
    LOOP
        FETCH v_cursor INTO v_id;
        EXIT WHEN NOT FOUND;
        UPDATE tallercursores12.envios
        SET observacion = 'Primera etapa del envio',
            estado = 'en_ruta'
        WHERE id = v_id;
    END LOOP;
    CLOSE v_cursor;
END;
$$;

CALL tallercursores12.primera_fase_envio();
select * from tallercursores12.envios;
--Ultima Fase de envio
CREATE OR REPLACE PROCEDURE tallercursores12.ultima_fase_envio() LANGUAGE plpgsql
AS $$
DECLARE
    v_cursor CURSOR FOR 
        SELECT id FROM tallercursores12.envios WHERE estado = 'en_ruta' AND fecha_envio <= CURRENT_DATE - INTERVAL '5 days';
    v_id INTEGER;
BEGIN
    OPEN v_cursor;
    LOOP
        FETCH v_cursor INTO v_id;
        EXIT WHEN NOT FOUND;

        UPDATE tallercursores12.envios SET estado = 'entregado', observacion = 'Envio realizado satisfactoriamente' WHERE id = v_id;
    END LOOP;
    CLOSE v_cursor;
END;
$$;

CALL tallercursores12.ultima_fase_envio();
select * from tallercursores12.envios;

