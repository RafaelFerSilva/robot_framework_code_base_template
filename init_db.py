import time
import mysql.connector

DB_HOST = "127.0.0.1"
DB_USER = "testuser"
DB_PASSWORD = "testpassword"
DB_NAME = "testdb"
INIT_SQL_FILE = "init.sql"  # SQL file path

# Maximum database waiting time (in seconds)
TIMEOUT = 60
INTERVAL = 5
elapsed_time = 0

while elapsed_time < TIMEOUT:
    try:
        print("Trying to connect to MySQL...")
        conn = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
        print("✅ Connected to MySQL successfully!")

        # Execute the SQL script
        cursor = conn.cursor()
        with open(INIT_SQL_FILE, "r") as f:
            sql_commands = f.read()
            for command in sql_commands.split(";"):
                if command.strip():
                    cursor.execute(command)

        conn.commit()
        cursor.close()
        conn.close()
        print("✅ Database initialized successfully!")
        break

    except mysql.connector.Error as e:
        print(f"⚠️ Error connecting to MySQL: {e}")
        elapsed_time += INTERVAL
        print(f"Aguardando {INTERVAL} seconds before trying again...")
        time.sleep(INTERVAL)
else:
    print("⛔ Timeout! MySQL is not available.")
    exit(1)
