FROM node:18-alpine

# Use the pre-release version
ARG N8N_VERSION=1.88.0

# Install system dependencies
RUN apk add --update --no-cache \
    graphicsmagick \
    tzdata \
    python3 \
    build-base \
    git

# Install n8n (no need to separately install n8n-nodes-mcp as it's now built-in)
RUN npm install -g n8n@${N8N_VERSION} \
    && npm cache clean --force

# Configure environment
ENV N8N_USER_FOLDER=/data
ENV N8N_CONFIG_FILES=/data/config
ENV N8N_PORT=5678
ENV N8N_DIAGNOSTICS_ENABLED=true

# Create data directory
RUN mkdir -p /data && chown -R node:node /data

WORKDIR /data
EXPOSE ${N8N_PORT}
USER node

CMD ["n8n", "start"]
