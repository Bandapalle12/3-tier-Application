from flask import Flask
import pymysql
import json
import os

app = Flask(__name__)

# Load RDS credentials from Secrets Manager (passed via ECS env)
raw_secret = os.getenv("RDS_SECRET")

if not raw_secret:
    raise RuntimeError("RDS_SECRET environment variable not set")

creds = json.loads(raw_secret.strip())
RDS_USERNAME = creds["username"]
RDS_PASSWORD = creds["password"]

# RDS config
RDS_HOST = os.getenv("RDS_HOST")
if not RDS_HOST:
    raise RuntimeError("RDS_HOST environment variable not set")

RDS_DB = "testdb"


@app.route("/")
def hello():
    try:
        conn = pymysql.connect(
            host=RDS_HOST,
            user=RDS_USERNAME,
            password=RDS_PASSWORD,
            database=RDS_DB,
            connect_timeout=5
        )
        with conn.cursor() as cursor:
            cursor.execute("SELECT 'RDS Connected!'")
            result = cursor.fetchone()
        conn.close()
        return f"Hello World from ECS → RDS! Message: {result[0]}"
    except Exception as e:
        return f"Error connecting to RDS: {str(e)}", 500


@app.route("/health")
def health():
    return "OK", 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
