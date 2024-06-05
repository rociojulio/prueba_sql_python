import pandas as pd
import mysql.connector
from mysql.connector import Error


def insertar_datos_desde_excel_a_tabla(file_path_excel, query_insercion, connection):
    try:
        if connection.is_connected():
            cursor = connection.cursor()
            print('Conexión exitosa a la base de datos')

            datos_df = pd.read_excel(file_path_excel)
            datos_df.fillna(0, inplace=True)

            
            tamano_batch = 1000
            num_batches = (len(datos_df) // tamano_batch) + 1

            for i in range(num_batches):
                indice_inicial = i * tamano_batch
                indice_final = min((i + 1) * tamano_batch, len(datos_df))
                batch_data = datos_df.iloc[indice_inicial:indice_final]
                values = [tuple(row) for row in batch_data.to_numpy()]

                cursor.executemany(query_insercion, values)
                connection.commit()

            print("Datos insertados correctamente")

    except Error as e:
        print('Error al insertar datos:', e)

    finally:
        if connection.is_connected():
            cursor.close()

try:
    
    connection = mysql.connector.connect(
        host='prueba-tecnica-rocio.cvuycuqcu7yp.us-east-2.rds.amazonaws.com',
        database='prueba_tasas_obligaciones',
        user='admin',
        password='adminroot'
    )

    if connection.is_connected():
        print('Conexión exitosa a la base de datos')

        file_path_obligaciones = './datos/Obligaciones_clientes.xlsx'
        query_insercion_obligaciones = """
            INSERT IGNORE INTO obligaciones_clientes (radicado, num_documento, cod_segm_tasa, cod_subsegm_tasa, 
            cal_interna_tasa, id_producto, tipo_id_producto, valor_inicial, fecha_desembolso, plazo, 
            cod_periodicidad, periodicidad, saldo_deuda, modalidad, tipo_plazo) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
        insertar_datos_desde_excel_a_tabla(file_path_obligaciones, query_insercion_obligaciones, connection)
        print("Datos insertados correctamente en obligaciones_clientes")

        
        file_path_tasas = './datos/tasas_productos.xlsx'
        query_insercion_tasas = """
            INSERT IGNORE INTO tasas_productos (cod_segmento,
            segmento, cod_subsegmento, calificacion_riesgos, tasa_cartera,tasa_operacion_especifica, tasa_hipotecario,
            tasa_leasing, tasa_sufi, tasa_factoring, tasa_tarjeta ) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
        insertar_datos_desde_excel_a_tabla(file_path_tasas, query_insercion_tasas, connection)
        print("Datos insertados correctamente en tasas_productos")

except Error as e:
    print('Error al conectarse a la base de datos:', e)

finally:
    if connection.is_connected():
        connection.close()
        print("Conexión MySQL cerrada")
