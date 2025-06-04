FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install required system packages and Node.js
RUN apt-get update && apt-get install -y \
    curl gnupg build-essential git yarn libpq-dev gcc \
    libjpeg-dev zlib1g-dev \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the wger repo into the container
COPY ./wger /app

# Install Python dependencies
RUN pip install --upgrade pip \
 && pip install -r requirements.txt

# Install JS dependencies and compile SCSS
RUN yarn install \
 && yarn run sass wger/core/static/scss/main.scss:wger/core/static/yarn/bootstrap-compiled.css

# Collect static files for Django
RUN python manage.py collectstatic --noinput

# Expose the app port (even though internally it's still 8000)
EXPOSE 8000

# Run the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
