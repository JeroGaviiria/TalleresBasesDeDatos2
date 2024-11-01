create table pagaya.usuarios(
	id serial primary key,
	nombre varchar,
	direccion varchar,
	email varchar,
	fecha_registro date,
	estado varchar

);



CREATE table pagaya.tarjetas (
    id serial primary key,
    numero_tarjeta varchar(16),
    fecha_expiracion DATE,
    cvv integer,
    tipo_tarjeta varchar(10) CHECK (tipo_tarjeta IN ('visa', 'mastercard'))
);

CREATE TABLE pagaya.productos (
    id serial primary key,
    codigo_producto varchar(50),
    nombre varchar(100),
    precio decimal(5,2),
    categoria varchar(20) CHECK (categoria IN ('celular', 'pc', 'televisor')),
    porcentaje_impuesto_precio decimal(5, 2)
);

CREATE TABLE pagaya.pagos (
    id serial primary key,
    codigo_pago varchar(50),
    fecha DATE,
    estado varchar(10) CHECK (estado IN ('exitoso', 'fallido')),
    monto decimal(10, 2),
    producto_id integer REFERENCES pagaya.productos(id),
    tarjeta_id integer REFERENCES pagaya.tarjetas(id),
    usuario_id integer REFERENCES pagaya.usuarios(id)
);

CREATE TABLE pagaya.comprobantes_pago (
    id serial primary key,
    detalle_xml xml,
    detalle_json json
);


insert into  pagaya.usuarios (nombre, direccion, email, fecha_registro, estado) values  
    ('Juan Perez', 'Calle 123', 'juan.perez@email.com', '2024-01-01', 'activo'),
    ('Maria Gomez', 'Avenida 456', 'maria.gomez@email.com', '2024-02-15', 'inactivo');


insert into pagaya.tarjetas (id,numero_tarjeta, fecha_expiracion, cvv, tipo_tarjeta) values 
    (1,'1234A', '2025-12-31', 123, 'visa'),
    (2,'1234B', '2026-06-30', 456, 'mastercard'),
    (3,'1235A', '2023-11-28', 123, 'mastercard');
   
  
   
insert into pagaya.productos (codigo_producto, nombre, precio, categoria, porcentaje_impuesto_precio) values   
    ('001', 'iPhone', 20.00, 'celular', 15.00),
    ('002', 'Laptop',30.00, 'pc', 18.00);
   
   
insert into pagaya.pagos (codigo_pago, fecha, estado, monto, producto_id, tarjeta_id, usuario_id) values  
    ('Pago001', '2024-05-9', 'exitoso', 1200.00, 1, 1, 1),
    ('Pago002', '2024-05-10', 'exitoso', 800.00, 2, 2, 2),
    ('Pago003', '2024-05-11', 'exitoso', 900.00, 1, 3, 1);
   

   
   
-- PRIMERA PREGUNTA

--Obtener Pagos

create or replace function pagaya.obtener_pagos_usuario(usuario_id_param INT, fecha_param DATE)
returns table(codigo_pago VARCHAR, nombre_producto VARCHAR, monto DECIMAL, estado VARCHAR) 
as $$
BEGIN
    RETURN QUERY
    SELECT p.codigo_pago, prod.nombre, p.monto, p.estado
    FROM pagaya.pagos p
    JOIN pagaya.productos prod ON p.producto_id = prod.id
    WHERE p.usuario_id = usuario_id_param AND p.fecha = fecha_param;
END;
$$ LANGUAGE plpgsql;



--Obtener Tarjatas

create or replace function pagaya.obtener_tarjetas_usuario_monto(usuario_id_param INT)
returns table(nombre_usuario VARCHAR, email VARCHAR, numero_tarjeta VARCHAR, cvv INT, tipo_tarjeta VARCHAR) 
as  $$
BEGIN
    RETURN QUERY
    SELECT u.nombre, u.email, t.numero_tarjeta, t.cvv, t.tipo_tarjeta
    FROM pagaya.tarjetas t
    JOIN pagaya.pagos p ON t.id = p.tarjeta_id
    JOIN pagaya.usuarios u ON p.usuario_id = u.id
    WHERE p.usuario_id = usuario_id_param AND p.monto > 1000;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM pagaya.obtener_tarjetas_usuario_monto(1);

-- SEGUNDA PREGUNTA

--Obtener Tarjeta con detalles
CREATE OR REPLACE FUNCTION pagaya.obtener_tarjetas_con_detalle(usuario_id_param INT)
RETURNS TABLE(detalle VARCHAR) AS $$
DECLARE
    numero_tarjeta VARCHAR;
    fecha_expiracion DATE;
    nombre VARCHAR;
    email VARCHAR;
    tarjeta_cursor CURSOR FOR
        SELECT t.numero_tarjeta, t.fecha_expiracion, u.nombre, u.email
        FROM pagaya.tarjetas t
        JOIN pagaya.pagos p ON t.id = p.tarjeta_id
        JOIN pagaya.usuarios u ON p.usuario_id = u.id
        WHERE u.id = usuario_id_param;
BEGIN
    OPEN tarjeta_cursor;
    LOOP
        FETCH tarjeta_cursor INTO numero_tarjeta, fecha_expiracion, nombre, email;
        EXIT WHEN NOT FOUND;
        
        detalle := 'Tarjeta: ' || numero_tarjeta ||
                   ', Expiración: ' || fecha_expiracion ||
                   ', Nombre: ' || nombre ||
                   ', Email: ' || email;
        RETURN NEXT;
    END LOOP;
    CLOSE tarjeta_cursor;
END;
$$ LANGUAGE plpgsql;


SELECT pagaya.obtener_tarjetas_con_detalle(2);

--Obtener pagos menores a $1.000
CREATE OR REPLACE FUNCTION pagaya.obtener_pagos_menores(fecha_param DATE)
RETURNS TABLE(detalle VARCHAR) AS $$
DECLARE
    monto DECIMAL;
    estado VARCHAR;
    nombre_producto VARCHAR;
    porcentaje_impuesto DECIMAL;
    direccion VARCHAR;
    email VARCHAR;
    pago_cursor CURSOR FOR
        SELECT p.monto, p.estado, prod.nombre, prod.porcentaje_impuesto_precio, u.direccion, u.email
        FROM pagaya.pagos p
        JOIN pagaya.productos prod ON p.producto_id = prod.id
        JOIN pagaya.usuarios u ON p.usuario_id = u.id
        WHERE p.monto < 1000 AND p.fecha = fecha_param;
BEGIN
    OPEN pago_cursor;
    LOOP
        FETCH pago_cursor INTO monto, estado, nombre_producto, porcentaje_impuesto, direccion, email;
        EXIT WHEN NOT FOUND;
        detalle := 'Monto: ' || monto || 
						', Estado: ' || nombre_producto ||
                           ', Nombre Producto: ' || nombre_producto || 
                           ', Porcentaje Impuesto: ' || porcentaje_impuesto || 
                           ', Direccion: ' || direccion || 
								', Email: ' || email ;
        RETURN NEXT;
    END LOOP;
    CLOSE pago_cursor;
END;
$$ LANGUAGE plpgsql;



SELECT pagaya.obtener_pagos_menores('2024-06-20');

--TERCERA PREGUNTA

--Validaciones Producto
CREATE OR REPLACE FUNCTION validaciones_producto()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.precio <= 0 OR NEW.precio >= 20000 THEN
        RAISE EXCEPTION 'El precio debe ser mayor a 0 y menor a 20000';
    END IF;

    IF NEW.porcentaje_impuesto_precio <= 1 OR NEW.porcentaje_impuesto_precio > 20 THEN
        RAISE EXCEPTION 'El porcentaje de impuesto debe ser mayor a 1%% y menor o igual a 20%%';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validaciones_producto
BEFORE INSERT ON pagaya.productos
FOR EACH ROW EXECUTE FUNCTION validaciones_producto();

--Prueba de Trigger
insert into pagaya.productos (codigo_producto, nombre, precio, categoria, porcentaje_impuesto_precio) values   
    ('003', 'LG', 30.00, 'televisor', 29.00);
   
   
-- Trigger XML
CREATE OR REPLACE FUNCTION trigger_xml()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO pagaya.comprobantes_pago (detalle_xml, detalle_json)
    VALUES (
        ('<pago><codigo_pago>' || NEW.codigo_pago || '</codigo_pago><fecha>' || NEW.fecha || '</fecha><estado>' || NEW.estado || '</estado><monto>' || NEW.monto || '</monto></pago>')::xml,
        ('{"codigo_pago": "' || NEW.codigo_pago || '", "fecha": "' || NEW.fecha || '", "estado": "' || NEW.estado || '", "monto": ' || NEW.monto || '}')::json
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_xml
AFTER INSERT ON pagaya.pagos
FOR EACH ROW EXECUTE FUNCTION trigger_xml();

INSERT INTO pagaya.pagos (codigo_pago, fecha, estado, monto, producto_id, tarjeta_id, usuario_id)
VALUES ('Pago005', '2024-11-01', 'exitoso', 1500.00, 1, 1, 1);

select * from pagaya.comprobantes_pago;
SELECT 
    array_to_string(xpath('//codigo_pago/text()', detalle_xml), '') AS codigo_pago,
    array_to_string(xpath('//fecha/text()', detalle_xml), '') AS fecha,
    array_to_string(xpath('//estado/text()', detalle_xml), '') AS estado,
    array_to_string(xpath('//monto/text()', detalle_xml), '') AS monto
FROM 
    pagaya.comprobantes_pago;
   
   
--CUARTA PREGUNTA
--Secuencias
   CREATE SEQUENCE pagaya.codigo_producto_seq
    START WITH 5
    INCREMENT BY 5;

CREATE SEQUENCE pagaya.codigo_pago_seq
    START WITH 1
    INCREMENT BY 100;






   























