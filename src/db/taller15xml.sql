CREATE TABLE taller15.libros (
    isbn BIGINT PRIMARY KEY,
    descripcion XML
);

INSERT INTO taller15.libros (isbn, descripcion) 
VALUES 
(9780131103627, xmlparse(document '<libro><titulo>El Quijote</titulo><autor>Miguel de Cervantes</autor><anio>1605</anio></libro>')),
(9780321751041, xmlparse(document '<libro><titulo>Old News</titulo><autor>George Orwell</autor><anio>1949</anio></libro>')),
(9780132350884, xmlparse(document '<libro><titulo>Brave New World</titulo><autor>Aldous Huxley</autor><anio>1932</anio></libro>'));

SELECT 
    isbn,
    xpath('//titulo/text()', descripcion)::TEXT AS titulo,
    xpath('//autor/text()', descripcion)::TEXT AS autor,
    xpath('//anio/text()', descripcion)::TEXT AS anio
FROM taller15.libros;


--1.
CREATE OR REPLACE PROCEDURE taller15.guardar_libro(
    p_isbn BIGINT,
    p_titulo TEXT,
    p_autor TEXT,
    p_anio INTEGER
)
AS $$
BEGIN
    INSERT INTO taller15.libros (isbn, descripcion)
    VALUES (
        p_isbn,
        XMLPARSE(DOCUMENT 
            '<libro><titulo>' || p_titulo || '</titulo>' || 
            '<autor>' || p_autor || '</autor>' || 
            '<anio>' || p_anio || '</anio></libro>'
        )
    );
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Error: ISBN o Titulo ya existe en la tabla libros.';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION taller15.verificar_unicidad_libro()
RETURNS TRIGGER AS $$
DECLARE
    v_titulo TEXT;
BEGIN
    v_titulo := xpath('//titulo/text()', NEW.descripcion)::text[] [1];
    IF EXISTS (
        SELECT 1 FROM taller15.libros 
        WHERE isbn = NEW.isbn OR 
              xpath('//titulo/text()', descripcion)::text[] @> ARRAY[v_titulo]
    ) THEN
        RAISE EXCEPTION 'ISBN o Titulo ya existe en la tabla libros.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER antes_insertar_libro
BEFORE INSERT ON taller15.libros
FOR EACH ROW
EXECUTE FUNCTION taller15.verificar_unicidad_libro();

--2.
CREATE OR REPLACE PROCEDURE taller15.actualizar_libro(
    p_isbn BIGINT,
    p_titulo TEXT,
    p_autor TEXT,
    p_anio INTEGER
)
AS $$
BEGIN
    UPDATE taller15.libros
    SET descripcion = XMLPARSE(DOCUMENT 
        '<libro><titulo>' || p_titulo || '</titulo>' || 
        '<autor>' || p_autor || '</autor>' || 
        '<anio>' || p_anio || '</anio></libro>'
    )
    WHERE isbn = p_isbn;
    IF NOT FOUND THEN
        RAISE NOTICE 'No se encontró un libro con el ISBN % para actualizar.', p_isbn;
    END IF;
END;
$$ LANGUAGE plpgsql;

--3.
CREATE OR REPLACE FUNCTION taller15.obtener_autor_libro_por_isbn(p_isbn BIGINT)
RETURNS TEXT AS $$
DECLARE
    v_autor TEXT[];
BEGIN
    SELECT xpath('//autor/text()', descripcion)::text[] INTO v_autor
    FROM taller15.libros
    WHERE isbn = p_isbn;

    IF v_autor IS NOT NULL AND array_length(v_autor, 1) > 0 THEN
        RETURN v_autor[1];
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;

--4.
CREATE OR REPLACE FUNCTION taller15.obtener_autor_libro_por_titulo(p_titulo TEXT)
RETURNS TEXT AS $$
DECLARE
    v_autor TEXT[];
BEGIN
    SELECT xpath('//autor/text()', descripcion)::text[] INTO v_autor
    FROM taller15.libros
    WHERE xpath('//titulo/text()', descripcion)::text[] @> ARRAY[p_titulo];

    IF v_autor IS NOT NULL AND array_length(v_autor, 1) > 0 THEN
        RETURN v_autor[1];
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;

--5.
CREATE OR REPLACE FUNCTION taller15.obtener_libros_por_anio(anio INTEGER)
RETURNS TABLE(isbn bigint, titulo TEXT, autor TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT
		l.isbn,
        (xpath('/libro/titulo/text()', descripcion))[1]::text AS titulo,
        (xpath('/libro/autor/text()', descripcion))[1]::text AS autor
    FROM 
        taller15.libros l
    WHERE 
        (xpath('/libro/anio/text()', descripcion))[1]::text = anio::text; 
END;
$$ LANGUAGE plpgsql;













