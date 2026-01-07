import boto3
import json

SECRET_NAME = "my-app-secret"
REGION = "ap-south-1"

client = boto3.client("secretsmanager", region_name=REGION)
response = client.get_secret_value(SecretId=SECRET_NAME)

secret = json.loads(response["SecretString"])

print("✅ Secret retrieved successfully")
print("DB USER:", secret["db_user"])
