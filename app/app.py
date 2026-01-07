import boto3
from flask import Flask

app = Flask(__name__)

def get_secret():
    try:
        ssm = boto3.client("ssm", region_name="ap-south-1")
        response = ssm.get_parameter(
            Name="/devops-assignment/app/SECRET_KEY",
            WithDecryption=True
        )
        secret = response["Parameter"]["Value"]
        print("✅ Secret fetched successfully")
        return secret
    except Exception as e:
        print("❌ Failed to fetch secret:", e)
        return None

SECRET_VALUE = get_secret()

@app.route("/")
def home():
    return "App is running successfully!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
