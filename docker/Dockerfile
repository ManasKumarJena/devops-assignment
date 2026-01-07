FROM python:3.9-slim

# Set working directory inside container
WORKDIR /app

# Copy requirements first (better caching)
COPY app/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/ .

# Expose Flask port
EXPOSE 5000

# Run application
CMD ["python", "app.py"]
