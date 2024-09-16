create table usuarios (
id serial primary key,
nombre varchar,
identificacion varchar not null unique,
edad int,
correo varchar
);

do $$
declare
    i int;
    id_prefix varchar(3);
    edad_random int;
begin
    for i in 1..50 loop
        id_prefix := 'A' || i;  
        edad_random := 18 + (random() * 62)::int;  

        insert into usuarios (nombre, identificacion, edad, correo)
        values ('Usuario ' || i, id_prefix, edad_random, 'usuario' || i || '@gmail.com');
    end loop;
end $$;

create table facturas (
    id_factura serial primary key,
    fecha date,
    producto varchar(255) not null,
    cantidad int,
    valor_unitario numeric(15, 2),
    valor_total numeric(15, 2),
    usuario_id int references usuarios(id)
);

do $$
declare
    i int;
    producto varchar(255);
    cantidad int;
    valor_unitario numeric(15, 2);
    valor_total numeric(15, 2);
    usuario_id int;
begin
    for i in 1..25 loop
        producto := 'Producto ' || i;  
        cantidad := 1 + (random() * 10)::int;  
        valor_unitario := 10 + (random() * 90)::numeric(15, 2);  
        valor_total := cantidad * valor_unitario;  
        usuario_id := 1 + (random() * 49)::int;  

        insert into facturas (fecha, producto, cantidad, valor_unitario, valor_total, usuario_id)
        values (
            current_date - (random() * 365)::int,  
            producto,
            cantidad,
            valor_unitario,
            valor_total,
            usuario_id
        );
    end loop;
end $$;

--Prueba Identificacion Unica
create or replace procedure prueba_identificacion_unica(
    p_nombre varchar,
    p_identificacion varchar,
    p_edad int,
    p_correo varchar
)
as $$
declare
    nueva_identificacion varchar;
begin
    
    begin
        insert into usuarios (nombre, identificacion, edad, correo)
        values (p_nombre, p_identificacion, p_edad, p_correo);

    exception
      
        when unique_violation then
            raise notice 'ERROR: La identificacion % ya existe. Creando nueva identificacion.', p_identificacion;
            
           '
            nueva_identificacion := p_identificacion || '-nuevo';

            
            insert into usuarios (nombre, identificacion, edad, correo)
            values (p_nombre, nueva_identificacion, p_edad, p_correo);
    end;
end;
$$ language plpgsql;

select * from usuarios;
--Llamada a Prueba Identificacion Unica
CALL prueba_identificacion_unica('Usuario Prueba', 'A1', 30, 'usuario_prueba@gmail.com');


-- Prueba Cliente Debe Existir
create or replace procedure prueba_cliente_debe_existir()
as $$
begin
    begin
        insert into facturas (fecha, producto, cantidad, valor_unitario, usuario_id)
        values (current_date, 'Producto 1', 2, 100.00, 1);  

    exception
        when foreign_key_violation then
            raise exception 'Error: El usuario no existe Transaccion cancelada.';
    end;

    begin
        insert into facturas (fecha, producto, cantidad, valor_unitario, usuario_id)
        values (current_date, 'Producto 2', 1, 50.00, 9999);  

    exception
        when foreign_key_violation then

			rollback;
            raise exception 'Error: El usario no existe. Transaccion cancelada.';
    end;

end;
$$ language plpgsql;
--Llamada a  Prueba Cliente Debe Existir
CALL prueba_cliente_debe_existir();

-- Prueba Producto Vacio
create or replace procedure prueba_producto_vacio()
as $$
begin
    insert into facturas (fecha, producto, cantidad, valor_unitario, usuario_id) 
    values (current_date, 'Producto 1', 10, 500.00, 1);
    insert into facturas (fecha, producto, cantidad, valor_unitario, usuario_id) 
    values (current_date, NULL, 5, 300.00, 1);

exception
    when others then
       
        raise exception 'Error: No se permite insertar un producto vacio. Operacion cancelada.';
        rollback;
end;
$$ language plpgsql;

-- Llamada a Prueba Producto Vacio
call prueba_producto_vacio();




 