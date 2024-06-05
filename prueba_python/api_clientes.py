from fastapi import FastAPI, HTTPException
import mysql.connector

app = FastAPI()

db = mysql.connector.connect(
    host='prueba-tecnica-rocio.cvuycuqcu7yp.us-east-2.rds.amazonaws.com',
    database='prueba_tasas_obligaciones',
    user='admin',
    password='adminroot'
)

@app.get('/tasa_cliente/{num_documento}')
async def obtener_datos_cliente(num_documento: int):
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM tasas_obligaciones_clientes WHERE num_documento =%s', (num_documento,))
    datos = cursor.fetchall()
    cursor.close()
    
    if not datos:
        raise HTTPException(status_code=404, detail='No se ha encontrado ningún cliente con el número de documento dado')
    
    return datos

@app.get('/total_cliente/{num_documento}')
async def obtener_total_cliente(num_documento:int):
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT num_documento, suma_valor_final FROM sumas_clientes WHERE num_documento = %s', (num_documento,))
    datos = cursor.fetchone()
    cursor.close()
    
    if not datos:
        raise HTTPException(status_code=404, detail='No se ha encontrado ningún cliente con el número de documento dado')
    
    return datos