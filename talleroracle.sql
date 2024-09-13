ALTER USER taller6plsql QUOTA UNLIMITED ON USERS;

CREATE TABLE clientes (
    id_cliente NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    identificacion VARCHAR2(50) UNIQUE,
    edad NUMBER,
    correo VARCHAR2(100)
);

CREATE TABLE productos (
    codigo_producto NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    stock NUMBER,
    valor_unitario NUMBER(10, 2)
);

	CREATE TABLE facturas (
	    id_factura NUMBER PRIMARY KEY,
	    fecha DATE,
	    cantidad NUMBER,
	    valor_total NUMBER(10, 2),
	    pedido_estado VARCHAR2(20) CHECK (pedido_estado IN ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO')),
	    producto_id NUMBER,
	    cliente_id NUMBER,
	    FOREIGN KEY (producto_id) REFERENCES productos(codigo_producto),
	    FOREIGN KEY (cliente_id) REFERENCES clientes(id_cliente)
	);

CREATE OR REPLACE PROCEDURE verificar_stock (
    p_producto_id IN NUMBER,
    p_cantidad_compra IN NUMBER
) IS
    v_stock NUMBER;
BEGIN
    -- Obtiene el stock del producto
    SELECT stock INTO v_stock
    FROM productos
    WHERE codigo_producto = p_producto_id;

    -- Verificaa si hay suficiente stock
    IF v_stock >= p_cantidad_compra THEN
        DBMS_OUTPUT.PUT_LINE('Existe suficiente stock.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe suficiente stock.');
    END IF;
    
EXCEPTION
    -- Maneja los  errores si el producto no existe
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Producto no encontrado.');
END;

BEGIN
    verificar_stock(1, 5);  
END;


