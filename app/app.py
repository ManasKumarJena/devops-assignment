import boto3
import json

print("App started...")

client = boto3.client('secretsmanager', region_name='ap-south-1')
response = client.get_secret_value(SecretId='demo/app')

secret = json.loads(response['SecretString'])
print("Secret fetched successfully:", secret["APP_MESSAGE"])
