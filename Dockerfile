FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl gnupg build-essential git yarn libpq-dev gcc \
    libjpeg-dev zlib1g-dev \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy code
COPY ./wger /app

# Show files (for debugging)
RUN ls -la /app

# Install Python packages
RUN pip install --upgrade pip && pip install -r /app/requirements.txt

# Install JS and build CSS
RUN yarn install \
 && yarn run sass wger/core/static/scss/main.scss:wger/core/static/yarn/bootstrap-compiled.css

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose internal port
EXPOSE 8000

# Start app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
