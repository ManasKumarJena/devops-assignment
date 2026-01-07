FROM python:3.10-slim

WORKDIR /app

COPY app/app.py .

RUN pip install boto3

CMD ["python", "app.py"]
