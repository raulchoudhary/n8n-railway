FROM node:18-alpine

ARG N8N_VERSION=1.84.2

USER root

RUN apk add --update graphicsmagick tzdata

RUN apk --update add --virtual build-dependencies python3 build-base && \
    npm_config_user=root npm install --location=global n8n@${N8N_VERSION} && \
    apk del build-dependencies

# Install Python 3 and pip
RUN apk add --update --no-cache python3 py3-pip

# Upgrade pip (optional but recommended)
RUN pip3 install --upgrade pip

# Install the Python libraries you need
RUN pip3 install python-docx PyPDF2


WORKDIR /data

EXPOSE $PORT

ENV N8N_USER_ID=root

CMD export N8N_PORT=$PORT && n8n start
