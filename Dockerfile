FROM node:20-alpine

# Create app directory and non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S ratm -u 1001

WORKDIR /app

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init git

# Copy package files
COPY --chown=ratm:nodejs package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force
RUN npm install -g tsx

# Copy application code
COPY --chown=ratm:nodejs . .

# Clone protobufs
RUN git clone https://github.com/meshtastic/protobufs.git src/protobufs

# Change ownership of all files to ratm user
RUN chown -R ratm:nodejs /app

# Switch to non-root user
USER ratm

# Expose port (if needed for health checks)
EXPOSE 3000

# Use dumb-init for proper signal handling
ENTRYPOINT ["dumb-init", "--"]

# Start the application
CMD ["tsx", "index.ts"]