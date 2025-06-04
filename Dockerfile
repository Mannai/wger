FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl gnupg build-essential git libpq-dev gcc \
    libjpeg-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy full project (including manage.py)
COPY . /app

# Install Python dependencies from wger/requirements.txt
RUN pip install --upgrade pip && pip install -r wger/requirements.txt

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose internal port (still 8000, mapped to 8565 outside)
EXPOSE 8000

# Run the Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
