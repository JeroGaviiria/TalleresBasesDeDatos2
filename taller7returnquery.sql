CREATE TABLE tipo_contrato (
    id SERIAL PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    salario_total DECIMAL(10, 2) NOT NULL
);

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    identificacion VARCHAR(50) UNIQUE NOT NULL,
    tipo_contrato_id INT NOT NULL,
    FOREIGN KEY (tipo_contrato_id) REFERENCES tipo_contrato(id)
);



CREATE TABLE conceptos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    porcentaje DECIMAL(5, 2) NOT NULL
);

CREATE TABLE nomina (
    id SERIAL PRIMARY KEY,
    mes INT CHECK (mes BETWEEN 1 AND 12) NOT NULL,
    año INT NOT NULL,
    fecha_pago DATE NOT NULL,
    total_devengado DECIMAL(10, 2) NOT NULL,
    total_deducciones DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    cliente_id INT NOT NULL
);

CREATE TABLE detalles_nomina (
    id SERIAL PRIMARY KEY,
    concepto_id INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    nomina_id INT NOT NULL,
    FOREIGN KEY (concepto_id) REFERENCES conceptos(id),
    FOREIGN KEY (nomina_id) REFERENCES nomina(id)
);



-- Poblar tipo_contrato
DO $$
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO tipo_contrato (descripcion, cargo, salario_total)
        VALUES ('Contrato ' || i, 'Cargo ' || i, ROUND((RANDOM() * 1000 + 1000)::numeric, 2));
    END LOOP;
END $$;

-- Poblar empleados
DO $$
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO empleados (nombre, identificacion, tipo_contrato_id)
        VALUES ('Empleado ' || i, 'A' || i, (SELECT FLOOR(RANDOM() * 10) + 1));
    END LOOP;
END $$;

-- Poblar conceptos
DO $$
BEGIN
    FOR i IN 1..15 LOOP
        INSERT INTO conceptos (codigo, nombre, porcentaje)
        VALUES ('C' || i, 'Concepto ' || i, ROUND((RANDOM() * 30)::numeric, 2));
    END LOOP;
END $$;

-- Poblar nomina
DO $$
BEGIN
    FOR i IN 1..5 LOOP
        INSERT INTO nomina (mes, año, fecha_pago, total_devengado, total_deducciones, total, cliente_id)
        VALUES (FLOOR(RANDOM() * 12) + 1, 2024, CURRENT_DATE, ROUND((RANDOM() * 5000 + 5000)::numeric, 2),
                ROUND((RANDOM() * 1000 + 500)::numeric, 2), ROUND((RANDOM() * 5000 + 5000)::numeric, 2), (SELECT FLOOR(RANDOM() * 10) + 1));
    END LOOP;
END $$;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

-- Poblar detalles_nomina
DO $$
BEGIN
    FOR i IN 1..15 LOOP
        INSERT INTO detalles_nomina (concepto_id, valor, nomina_id)
        VALUES ((SELECT FLOOR(RANDOM() * 15) + 1), ROUND((RANDOM() * 1000 + 100)::numeric, 2), (SELECT FLOOR(RANDOM() * 5) + 1));
    END LOOP;
END $$;

-- Crear Contrato
CREATE OR REPLACE FUNCTION crear_contrato(
    p_descripcion VARCHAR,
    p_cargo VARCHAR,
    p_salario_total DECIMAL(10, 2)
) RETURNS TABLE(contrato_id INT, contrato_descripcion VARCHAR, contrato_cargo VARCHAR, contrato_salario_total DECIMAL(10, 2)) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM tipo_contrato WHERE cargo = p_cargo) THEN
        INSERT INTO tipo_contrato (descripcion, cargo, salario_total)
        VALUES (p_descripcion, p_cargo, p_salario_total)
        RETURNING id, descripcion, cargo, salario_total INTO contrato_id, contrato_descripcion, contrato_cargo, contrato_salario_total;
        RETURN NEXT;  
    ELSE
        RAISE EXCEPTION 'El cargo "%s" ya existe.', p_cargo;
    END IF;
END; $$ LANGUAGE plpgsql;

SELECT * FROM crear_contrato('Contrato Temporal', 'Desarrollador', 1500.00);


--Crear Empleado
CREATE OR REPLACE FUNCTION crear_empleado(
    p_nombre VARCHAR,
    p_identificacion VARCHAR,
    p_tipo_contrato_id INT
) RETURNS TABLE(empleado_id INT, empleado_nombre VARCHAR, empleado_identificacion VARCHAR, empleado_tipo_contrato_id INT) AS $$
BEGIN
    -- Verificar que la identificación sea única
    IF NOT EXISTS (SELECT 1 FROM empleados WHERE identificacion = p_identificacion) THEN
        INSERT INTO empleados (nombre, identificacion, tipo_contrato_id)
        VALUES (p_nombre, p_identificacion, p_tipo_contrato_id)
        RETURNING id, nombre, identificacion, tipo_contrato_id INTO empleado_id, empleado_nombre, empleado_identificacion, empleado_tipo_contrato_id;
        
        RETURN QUERY SELECT empleado_id, empleado_nombre, empleado_identificacion, empleado_tipo_contrato_id;
    ELSE
        RAISE EXCEPTION 'La identificación "%s" ya existe.', p_identificacion;
    END IF;
END; $$ LANGUAGE plpgsql;

SELECT * FROM crear_empleado('Juan Pérez', 'A12345', 1);

