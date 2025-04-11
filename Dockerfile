FROM node:18-alpine

ARG N8N_VERSION=1.84.2

USER root

# Install dependencies
RUN apk add --update graphicsmagick tzdata && \
    apk --update add --virtual build-dependencies python3 build-base

# Install n8n and MCP node
RUN npm_config_user=root npm install --location=global n8n@${N8N_VERSION} n8n-nodes-mcp@latest && \
    apk del build-dependencies

# Set up environment
WORKDIR /data
EXPOSE $PORT
ENV N8N_USER_ID=root
ENV NODE_PATH=/usr/local/lib/node_modules

# Ensure proper permissions
RUN chown -R root:root /usr/local/lib/node_modules && \
    chmod -R 755 /usr/local/lib/node_modules

CMD export N8N_PORT=$PORT && n8n start
