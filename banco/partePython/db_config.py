# db_config.py
import mysql.connector
from mysql.connector import Error

def conectar_db(host, usuario, senha, db_name=None):
    
    try:
        conn = mysql.connector.connect(
            host=host,
            user=usuario,
            password=senha,
            database=db_name
        )
        if conn.is_connected():
          
            return conn
    except Error as e:
        print(f"Erro ao conectar ao MySQL: {e}")
        return None
