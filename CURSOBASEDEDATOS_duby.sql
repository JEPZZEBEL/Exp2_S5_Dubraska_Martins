--desafio 1

SELECT 
    c.numrun AS rut,
    c.pnombre || ' ' || c.appaterno || ' ' || NVL(c.apmaterno, '') AS nombre,
    p.nombre_prof_ofic AS profesion,
    TO_CHAR(c.fecha_inscripcion, 'YYYY-MM-DD') AS fecha_inscripcion,
    c.direccion
FROM 
    cliente c
JOIN 
    profesion_oficio p ON c.cod_prof_ofic = p.cod_prof_ofic
WHERE 
    p.nombre_prof_ofic IN ('Contador', 'Vendedor')
    AND EXTRACT(YEAR FROM c.fecha_inscripcion) > (
        SELECT ROUND(AVG(EXTRACT(YEAR FROM fecha_inscripcion)))
        FROM cliente
    )
ORDER BY 
    c.numrun ASC;

---Desafio 2

CREATE TABLE CLIENTES_CUPOS_COMPRA (
    rut NUMBER(10) NOT NULL,
    edad NUMBER(3) NOT NULL,
    cupo_disponible NUMBER(10, 2) NOT NULL,
    CONSTRAINT PK_CLIENTES_CUPOS_COMPRA PRIMARY KEY (rut)
);

ALTER TABLE CLIENTES_CUPOS_COMPRA ADD (
    tipo_cliente VARCHAR2(30)
);

INSERT INTO CLIENTES_CUPOS_COMPRA (rut, edad, cupo_disponible, tipo_cliente)
SELECT 
    c.numrun AS rut,
    FLOOR(MONTHS_BETWEEN(SYSDATE, c.fecha_nacimiento) / 12) AS edad,
    t.cupo_disp_compra AS cupo_disponible,
    tc.nombre_tipo_cliente AS tipo_cliente
FROM 
    cliente c
JOIN 
    tarjeta_cliente t ON c.numrun = t.numrun
JOIN 
    tipo_cliente tc ON c.cod_tipo_cliente = tc.cod_tipo_cliente
WHERE 
    t.cupo_disp_compra >= (
        SELECT NVL(MAX(t.cupo_disp_compra), 0)
        FROM tarjeta_cliente t
        JOIN cliente c ON c.numrun = t.numrun
        WHERE EXTRACT(YEAR FROM c.fecha_inscripcion) = EXTRACT(YEAR FROM SYSDATE) - 1
    );

SELECT * FROM CLIENTES_CUPOS_COMPRA;

