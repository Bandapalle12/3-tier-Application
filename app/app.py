from flask import Flask
import pymysql
import json
import os

app = Flask(__name__)

raw_secret = os.getenv("RDS_SECRET")        #load secert from ECS

if raw_secret:
    cleaned = raw_secret.strip().replace("\r", "").replace("\n", "")
    creds = json.loads(cleaned)

    rds_username = creds.get("username")
    rds_password = creds.get("password")
else:
    rds_username = None
    rds_password = None

# RDS HOST
RDS_HOST = os.getenv("RDS_HOST")
RDS_DB = "testdb"


@app.route("/")
def hello():
    try:
        conn = pymysql.connect(
            host=RDS_HOST,
            user=rds_username,
            password=rds_password,
            database=RDS_DB
        )
        cursor = conn.cursor()
        cursor.execute("SELECT 'RDS Connected!'")
        result = cursor.fetchone()
        return f"Hello World from ECS → RDS! Message: {result[0]}"
    except Exception as e:
        return f"Error connecting to RDS: {str(e)}"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
