FROM node:18-alpine

# Use latest n8n version
ARG N8N_VERSION=1.86.1

# Install system dependencies
RUN apk add --update --no-cache \
    graphicsmagick \
    tzdata \
    python3 \
    build-base \
    git \
    && npm install -g npm@latest

# Install n8n and community nodes with clean cache
RUN npm install -g \
    n8n@${N8N_VERSION} \
    n8n-nodes-mcp@latest \
    && npm cache clean --force

# Create and configure data directory
RUN mkdir -p /data \
    && chown -R node:node /data \
    && chmod -R 755 /data

# Environment variables
ENV N8N_USER_FOLDER=/data
ENV NODE_PATH=/usr/local/lib/node_modules
ENV N8N_CONFIG_FILES=/data/config
ENV N8N_USER=node
ENV N8N_PORT=5678
ENV N8N_CUSTOM_EXTENSIONS="/usr/local/lib/node_modules"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
    CMD wget --no-verbose --tries=1 --spider http://localhost:${N8N_PORT}/healthz || exit 1

WORKDIR /data
EXPOSE ${N8N_PORT}
USER node

CMD ["n8n", "start"]
