create table taller13.empleado (
nombre varchar,
identificacion varchar primary key,
edad int,
correo varchar unique,
salario numeric(10, 2)
);

INSERT INTO taller13.empleado (nombre, identificacion, edad, correo, salario) 
VALUES 
('Carlos', 'A1', 35, 'carlos@example.com', 5000000),
('Ana', 'A2', 29, 'ana.@example.com', 4800000);

create table taller13.nomina (
id serial primary key,
fecha date,
total_ingresos numeric(20,2),
total_deducciones numeric(20,2),
total_neto numeric(20,2),
empleado_id VARCHAR REFERENCES taller13.empleado(identificacion)
);

INSERT INTO taller13.nomina (id,fecha, total_ingresos, total_deducciones, total_neto, empleado_id)
VALUES
(1,'2024-09-15', 6000000, 1000000, 5000000, 'A1'),  
(2,'2024-10-30', 5500000, 800000, 4700000, 'A2');  

create table taller13.detalle_nomina(
concepto varchar,
tipo varchar,
valor numeric(20,2),
nomina_id integer references taller13.nomina(id)
);

INSERT INTO taller13.detalle_nomina (concepto, tipo, valor, nomina_id) 
VALUES 
('Salario básico', 'Ingreso', 5000000, 1),  
('Descuento de pensión', 'Deducción', 800000, 2);  


create table taller13.auditoria_nomina(
id integer primary key,
fecha date,
total_ingresos numeric(20,2),
total_deducciones numeric(20,2),
total_neto numeric(20,2),
empleado_id VARCHAR REFERENCES taller13.empleado(identificacion)
);

create table taller13.auditoria_empleado (
nombre varchar,
fecha date,
identificacion varchar primary key,
edad int,
correo varchar unique,
salario numeric(10, 2)
);

-- 1.
CREATE OR REPLACE FUNCTION insertar_nomina() 
RETURNS TRIGGER AS $$
DECLARE
    total_mes NUMERIC(20, 2);
    mes_actual DATE := DATE_TRUNC('month', NEW.fecha);
BEGIN
    SELECT COALESCE(SUM(total_ingresos), 0)
    INTO total_mes
    FROM taller13.nomina
    WHERE empleado_id = NEW.empleado_id
    AND DATE_TRUNC('month', fecha) = mes_actual;

    IF (total_mes + NEW.total_ingresos) > 12000000 THEN
        RAISE EXCEPTION 'El empleado ha superado el límite de $12,000,000 en el mes';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

create trigger tg_validar_nomina
before insert on taller13.nomina
for each row execute procedure taller13.insertar_nomina();

--Verificación de Trigger 1
INSERT INTO taller13.nomina (fecha, total_ingresos, total_deducciones, total_neto, empleado_id)
VALUES ('2024-09-20', 4000000, 500000, 3500000, 'A1');

select * from taller13.nomina;

INSERT INTO taller13.nomina (fecha, total_ingresos, total_deducciones, total_neto, empleado_id)
VALUES ('2024-09-25', 3000000, 200000, 2800000, 'A1');

select * from taller13.nomina;

--2.
create OR replace function auditoria_nomina()
returns trigger AS $$
BEGIN
    INSERT INTO taller13.auditoria_nomina (id, fecha, total_ingresos, total_deducciones, total_neto, empleado_id)
    VALUES (NEW.id, NEW.fecha, NEW.total_ingresos, NEW.total_deducciones, NEW.total_neto, NEW.empleado_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_auditoria_nomina
AFTER INSERT ON taller13.nomina
FOR EACH ROW EXECUTE FUNCTION auditoria_nomina();

--3. 
CREATE OR REPLACE FUNCTION validar_presupuesto_nomina()
RETURNS TRIGGER AS $$
DECLARE
    total_salarios NUMERIC(20, 2);
BEGIN
    SELECT COALESCE(SUM(salario), 0)
    INTO total_salarios
    FROM taller13.empleado
    WHERE identificacion != NEW.identificacion;

     IF (total_salarios + NEW.salario) > 12000000 THEN
        RAISE EXCEPTION 'El salario total supera el presupuesto de $12,000,000';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_validar_salario
BEFORE UPDATE ON taller13.empleado
FOR EACH ROW
WHEN (OLD.salario IS DISTINCT FROM NEW.salario) 
EXECUTE FUNCTION validar_presupuesto_nomina();

--4.
CREATE OR REPLACE FUNCTION auditoria_empleado()
RETURNS TRIGGER AS $$
DECLARE
    diferencia NUMERIC(10, 2);
    concepto VARCHAR;
BEGIN
    diferencia := NEW.salario - OLD.salario;

    IF diferencia > 0 THEN
        concepto := 'AUMENTO';
    ELSIF diferencia < 0 THEN
        concepto := 'DISMINUCIÓN';
        diferencia := ABS(diferencia);
    ELSE
        RETURN NEW;
    END IF;
    INSERT INTO taller13.auditoria_empleado (nombre, fecha, identificacion, salario, concepto, valor)
    VALUES (NEW.nombre, CURRENT_DATE, NEW.identificacion, NEW.salario, concepto, diferencia);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_auditar_cambio_salario
AFTER UPDATE OF salario ON taller13.empleado
FOR EACH ROW
EXECUTE FUNCTION auditar_cambio_salario();




	