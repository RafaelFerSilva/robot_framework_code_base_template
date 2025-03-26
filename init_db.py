import time
import mysql.connector

DB_HOST = "127.0.0.1"
DB_USER = "testuser"
DB_PASSWORD = "testpassword"
DB_NAME = "testdb"
INIT_SQL_FILE = "init.sql"  # Caminho do arquivo SQL

# Tempo máximo de espera pelo banco (em segundos)
TIMEOUT = 60
INTERVAL = 5
elapsed_time = 0

while elapsed_time < TIMEOUT:
    try:
        print("Tentando conectar ao MySQL...")
        conn = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
        print("✅ Conectado ao MySQL com sucesso!")

        # Executa o script SQL
        cursor = conn.cursor()
        with open(INIT_SQL_FILE, "r") as f:
            sql_commands = f.read()
            for command in sql_commands.split(";"):
                if command.strip():
                    cursor.execute(command)

        conn.commit()
        cursor.close()
        conn.close()
        print("✅ Banco de dados inicializado com sucesso!")
        break

    except mysql.connector.Error as e:
        print(f"⚠️ Erro ao conectar ao MySQL: {e}")
        elapsed_time += INTERVAL
        print(f"Aguardando {INTERVAL} segundos antes de tentar novamente...")
        time.sleep(INTERVAL)
else:
    print("⛔ Timeout! O MySQL não está disposível.")
    exit(1)
