## 1.	DESARROLLO DE CONSULTA SQL.
Base de datos creada en: Amazon Web Services.
Motor de base de la base de datos: MySQL
Tablas creadas: 
•	obligaciones_clientes: esta tabla almacena las obligaciones de los clientes con datos como numero_documento, valor, producto etc. Clave primaria: clave primaria: (radicado, num_documento, id_producto, valor_inicial, fecha_desembolso).
•	tasas_productos: contiene las tasas de interés por cada producto. clave primaria: (cod_segmento, cod_subsegmento, calificacion_riesgos).
•	tasas_obligaciones_clientes: contiene información sobre las tasas aplicadas a cada cliente basándose en las características de sus productos.
•	sumas_clientes: contiene información consolidada por cliente de la suma de los valores totales.
Para alimentar las tablas principales, debido a problemas de MySQL de importar datos xlsx se creó un código (exportar_excel_a_sql.py) con Python y Pandas el cual permitió hacer la ingestión mientras hacía limpieza la limpieza de los datos para mejor procesamiento en la base de datos.
Resultados obtenidos:
 
 

## 2.	DESARROLLO CON PANDAS Y PYHTON.
Este desarrollo es un análogo al anteriormente explicado, el propósito fue replicar la funcionalidad de una consulta SQL mediante manipulación de datos con Python y Pandas.
La tarea consistió en:
1.	Cargar datos de ejemplo en DataFrames pandas.
2.	Unir los DataFrames según las condiciones especificadas en una consulta SQL.
3.	Aplicar lógica condicional para calcular tasas de interés y valores finales.
4.	Realizar agregaciones y agrupaciones de datos para calcular sumas y conteos por cliente.
5.	Presentar los resultados finales en un DataFrame pandas.
La implementación de este desarrollo se encuentra en el archivo análogo_pandas.py


Resultados:
Dataframe con la tasa efectiva y valor final aplicado
 
Dataframe con los datos agrupados por documento del cliente
 

## 3.	CREACIÓN DE API CON PYTHON
Esta prueba técnica consiste en desarrollar una API utilizando FastAPI y MySQL para proporcionar información sobre tasas de obligaciones financieras de clientes.
El objetivo principal del código es crear un servicio web que permita a los usuarios consultar las tasas de interés de las obligaciones financieras de los clientes.
El código consta de dos rutas principales:
/tasa_cliente/{num_documento}: Permite obtener información sobre las tasas de obligaciones financieras de un cliente específico mediante su número de documento.
 
/total_cliente/{num_documento}: Devuelve el total de la deuda de un cliente según su número de documento.
 
NOTA: vale la pena recalcar que todo este código está escrito para un ambiente de desarrollo y que no cumple con las condiciones de seguridad para un ambiente de producción.






