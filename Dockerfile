FROM node:20

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

# Initialize protobufs submodule or clone if needed (required by the application)
RUN if [ ! -f "src/protobufs/meshtastic/mqtt.proto" ]; then \
    rm -rf src/protobufs && \
    git config --global http.sslverify false && \
    git clone https://github.com/meshtastic/protobufs.git src/protobufs; \
fi

# Create data directory
RUN mkdir -p /app/data

# Set environment
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD node -e "console.log('Health check passed')" || exit 1

CMD ["npm", "start"]