FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# COPY source dest
# the app folder content to the container
COPY ./app /app
WORKDIR /app

# just documentation 
EXPOSE 8000

ARG DEV=false
# this runs when we are building the image
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

# to avoid using the full path when running commands when app is running
ENV PATH="/py/bin:$PATH"

# to avoid using the root user
USER django-user