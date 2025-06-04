FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y \
    curl gnupg build-essential git yarn \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY ./wger /app

RUN pip install --upgrade pip && pip install -r requirements.txt

RUN yarn install \
    && yarn run sass wger/core/static/scss/main.scss:wger/core/static/yarn/bootstrap-compiled.css

RUN python manage.py collectstatic --noinput

EXPOSE ${WGER_PORT}
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
