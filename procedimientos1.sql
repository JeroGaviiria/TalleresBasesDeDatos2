--Craer Cuenta
CREATE OR REPLACE PROCEDURE crear_cuenta(p_nombre VARCHAR,
p_email VARCHAR)

LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Cuenta creada con éxito: Nombre = %, Email = %', p_nombre, p_email;
END;
$$;

--Borrar Cuenta
CREATE OR REPLACE PROCEDURE borrar_cuenta(p_email VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Cuenta borrada con éxito: Email = %', p_email;
END;
$$;
