FROM node:18-alpine

ARG N8N_VERSION=1.84.2

USER root

RUN apk add --update graphicsmagick tzdata

RUN apk --update add --virtual build-dependencies python3 build-base && \
    npm_config_user=root npm install --location=global n8n@${N8N_VERSION} && \
    apk del build-dependencies

RUN pip install python-docx PyPDF2

WORKDIR /data

EXPOSE $PORT

ENV N8N_USER_ID=root

CMD export N8N_PORT=$PORT && n8n start
