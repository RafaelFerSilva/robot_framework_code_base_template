"""
Database Initialization Script

This script initializes a MySQL database by:
1. Establishing a connection to the MySQL server
2. Executing SQL commands from an initialization file
3. Implementing a retry mechanism with timeout

The script will attempt to connect to the database multiple times
until successful or until the timeout period is reached.
"""

import time
import mysql.connector

# Database connection parameters
DB_HOST = "127.0.0.1"
DB_USER = "testuser"
DB_PASSWORD = "testpassword"
DB_NAME = "testdb"
INIT_SQL_FILE = "init.sql"  # Path to SQL initialization file

# Retry mechanism configuration
TIMEOUT = 60      # Maximum waiting time in seconds
INTERVAL = 5      # Time between connection attempts in seconds
elapsed_time = 0  # Tracks total elapsed time

# Attempt to connect to the database with retry logic
while elapsed_time < TIMEOUT:
    try:
        print("Trying to connect to MySQL...")
        # Establish database connection
        conn = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
        print("✅ Connected to MySQL successfully!")

        # Execute the SQL initialization script
        cursor = conn.cursor()
        with open(INIT_SQL_FILE, "r") as f:
            sql_commands = f.read()
            # Split and execute each SQL command separately
            for command in sql_commands.split(";"):
                if command.strip():
                    cursor.execute(command)

        # Commit changes and clean up
        conn.commit()
        cursor.close()
        conn.close()
        print("✅ Database initialized successfully!")
        break

    except mysql.connector.Error as e:
        # Handle connection errors
        print(f"⚠️ Error connecting to MySQL: {e}")
        elapsed_time += INTERVAL
        print(f"Waiting {INTERVAL} seconds before trying again...")
        time.sleep(INTERVAL)
else:
    # Exit if timeout is reached
    print("⛔ Timeout! MySQL is not available.")
    exit(1)