CREATE TABLE IF NOT EXISTS tasas_productos (
    cod_segmento VARCHAR(50),
    segmento VARCHAR(100),
    cod_subsegmento VARCHAR(50),
    calificacion_riesgos VARCHAR(50),
    tasa_cartera DOUBLE,
    tasa_operacion_especifica DOUBLE,
    tasa_hipotecario DOUBLE,
    tasa_leasing DOUBLE,
    tasa_sufi DOUBLE,
    tasa_factoring DOUBLE,
    tasa_tarjeta DOUBLE,
    PRIMARY KEY (cod_segmento, cod_subsegmento, calificacion_riesgos)
);

CREATE TABLE IF NOT EXISTS obligaciones_clientes (
    radicado BIGINT,
    num_documento BIGINT,
    cod_segm_tasa VARCHAR(45),
    cod_subsegm_tasa VARCHAR(10),
    cal_interna_tasa VARCHAR(15),
    id_producto VARCHAR(100),
    tipo_id_producto VARCHAR(45),
    valor_inicial DOUBLE,
    fecha_desembolso TIMESTAMP,
    plazo DOUBLE,
    cod_periodicidad DECIMAL(5, 0),
    periodicidad VARCHAR(15),
    saldo_deuda DOUBLE,
    modalidad VARCHAR(15),
    tipo_plazo VARCHAR(10),
    PRIMARY KEY(radicado, num_documento, id_producto, valor_inicial, fecha_desembolso)
);

CREATE TABLE IF NOT EXISTS tasas_obligaciones_clientes (
    radicado BIGINT,
    num_documento BIGINT,
    id_producto VARCHAR(100),
    valor_inicial DOUBLE,
    tasa DOUBLE,
    periodicidad VARCHAR(50),
    tasa_efectiva DOUBLE,
    valor_final DOUBLE
);

INSERT INTO tasas_obligaciones_clientes (radicado, num_documento, id_producto, valor_inicial, tasa, periodicidad, tasa_efectiva, valor_final)
SELECT 
    obl.radicado,
    obl.num_documento,
    obl.id_producto,
    obl.valor_inicial,tasas_obligaciones_clientestasas_obligaciones_clientes,tasas_obligaciones_clientes,
    CASE 
        WHEN lower(obl.id_producto) like '%cartera%' and obl.id_producto not like lower('%leasing%') THEN t.tasa_cartera
        WHEN lower(obl.id_producto) like '%operacion_especifica%' THEN t.tasa_operacion_especifica
        WHEN lower(obl.id_producto) like '%hipotecario%' THEN t.tasa_hipotecario
        WHEN lower(obl.id_producto) like '%leasing%' THEN t.tasa_leasing
        WHEN lower(obl.id_producto) like '%sufi%' THEN t.tasa_sufi
        WHEN lower(obl.id_producto) like '%factoring%' THEN t.tasa_factoring
        WHEN lower(obl.id_producto) like '%tarjeta%' THEN t.tasa_tarjeta
        ELSE 0
    END AS tasa,
    obl.periodicidad,
    (
        POWER(1 + CASE 
            WHEN lower(obl.id_producto) like '%cartera%' and obl.id_producto not like lower('%leasing%') THEN t.tasa_cartera
			WHEN lower(obl.id_producto) like '%operacion_especifica%' THEN t.tasa_operacion_especifica
			WHEN lower(obl.id_producto) like '%hipotecario%' THEN t.tasa_hipotecario
			WHEN lower(obl.id_producto) like '%leasing%' THEN t.tasa_leasing
			WHEN lower(obl.id_producto) like '%sufi%' THEN t.tasa_sufi
			WHEN lower(obl.id_producto) like '%factoring%' THEN t.tasa_factoring
			WHEN lower(obl.id_producto) like '%tarjeta%' THEN t.tasa_tarjeta
            ELSE 0
        END, 1 / 
            CASE 
                WHEN obl.periodicidad = 'MENSUAL' THEN 12
                WHEN obl.periodicidad = 'BIMENSUAL' THEN 6
                WHEN obl.periodicidad = 'TRIMESTRAL' THEN 4
                WHEN obl.periodicidad = 'SEMESTRAL' THEN 2
                WHEN obl.periodicidad = 'ANUAL' THEN 1
                ELSE 1
            END
        ) - 1
    ) AS tasa_efectiva,
    (
        (
            POWER(1 + CASE 
                WHEN lower(obl.id_producto) like '%cartera%' and obl.id_producto not like lower('%leasing%') THEN t.tasa_cartera
				WHEN lower(obl.id_producto) like '%operacion_especifica%' THEN t.tasa_operacion_especifica
				WHEN lower(obl.id_producto) like '%hipotecario%' THEN t.tasa_hipotecario
				WHEN lower(obl.id_producto) like '%leasing%' THEN t.tasa_leasing
				WHEN lower(obl.id_producto) like '%sufi%' THEN t.tasa_sufi
				WHEN lower(obl.id_producto) like '%factoring%' THEN t.tasa_factoring
				WHEN lower(obl.id_producto) like '%tarjeta%' THEN t.tasa_tarjeta
                ELSE 0
            END, 1 / 
                CASE 
                    WHEN obl.periodicidad = 'MENSUAL' THEN 12
					WHEN obl.periodicidad = 'BIMENSUAL' THEN 6
					WHEN obl.periodicidad = 'TRIMESTRAL' THEN 4
					WHEN obl.periodicidad = 'SEMESTRAL' THEN 2
					WHEN obl.periodicidad = 'ANUAL' THEN 1
                    ELSE 1
                END
            ) - 1
        ) * obl.valor_inicial
    ) AS valor_final
FROM 
    obligaciones_clientes obl
JOIN 
    tasas_productos t ON obl.cod_segm_tasa = t.cod_segmento AND obl.cod_subsegm_tasa = t.cod_subsegmento AND obl.cal_interna_tasa = t.calificacion_riesgos;
    
    CREATE TABLE IF NOT EXISTS sumas_clientes (
    num_documento BIGINT PRIMARY KEY,
    suma_valor_final DOUBLE,
    cantidad_productos INT
);

INSERT INTO sumas_clientes (num_documento, suma_valor_final, cantidad_productos)
SELECT 
    t.num_documento,
    SUM(t.valor_final) AS suma_valor_final,
    COUNT(DISTINCT t.id_producto) AS cantidad_productos
FROM 
    tasas_obligaciones_clientes t
GROUP BY 
    t.num_documento
HAVING 
    COUNT(DISTINCT t.id_producto) >= 2;
