# RATM Meshtastic Discord Bot

The Rage Against The Mesh(ine) project is a TypeScript Node.js application that bridges Meshtastic MQTT mesh networking messages to Discord webhooks. It monitors MQTT topics for Meshtastic traffic and forwards formatted messages to Discord channels.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Essential Setup Commands
- Initialize git submodules: `git submodule update --init --recursive` -- REQUIRED: Downloads Meshtastic protobufs. Takes 1-5 seconds.
- Install dependencies: `npm install` -- Takes 4-20 seconds. NEVER CANCEL.
- Environment setup: Copy `.env.example` to `.env` and configure required variables
- Test TypeScript compilation: `npx tsc --noEmit` -- Will show errors but app runs fine with tsx

### Running the Application
- **Development mode**: `DISCORD_WEBHOOK_URL=<webhook> MQTT_TOPIC=<topic> npm start`
- **Docker development**: `docker compose up -d` -- Takes 2-3 minutes first time, 3 seconds with cache. NEVER CANCEL.
- **Docker with Redis**: `docker compose --profile redis up -d` -- Adds Redis for persistent storage
- **Stop Docker**: `docker compose down`

### Build and Deploy
- **Docker build**: `docker build -t ratm-test .` -- Takes 80-120 seconds. NEVER CANCEL. Set timeout to 180+ seconds.
- **Docker Compose build**: `docker compose build` -- Takes 80-120 seconds first time, 3 seconds with cache. NEVER CANCEL.
- **CapRover deployment**: Configured via `captain-definition` file
- **Replit deployment**: Configured via `.replit` and `replit.nix` files

### Testing and Validation
- **Basic startup test**: App requires DISCORD_WEBHOOK_URL or exits with error after 2-3 seconds
- **Full functionality test**: App connects to MQTT broker and runs indefinitely when properly configured
- **Docker health check**: `docker compose logs mesh-bot` shows startup logs
- **Redis connectivity**: `docker compose logs redis` shows Redis ready message

## Validation Scenarios

**ALWAYS test these scenarios after making changes:**

1. **Clean install validation**:
   ```bash
   git submodule update --init --recursive
   npm install
   DISCORD_WEBHOOK_URL=http://localhost:8080/test MQTT_TOPIC=msh/US/bayarea npm start
   ```
   Expected: App starts and runs without error (test for 10-30 seconds)

2. **Docker validation**:
   ```bash
   docker compose build
   docker compose up -d
   docker compose logs mesh-bot
   docker compose down
   ```
   Expected: Container builds, starts, and shows "Starting Rage Against Mesh(ine)" log

3. **Redis integration validation**:
   ```bash
   docker compose --profile redis up -d
   docker compose logs redis
   docker compose logs mesh-bot
   ```
   Expected: Both containers start successfully

## Environment Configuration

### Required Variables
- `DISCORD_WEBHOOK_URL`: Discord webhook for message forwarding
- `MQTT_TOPIC`: MQTT topic to monitor (default: msh/US/bayarea)

### Optional Variables (with defaults)
- `MQTT_BROKER_URL`: mqtt://mqtt.bayme.sh
- `MQTT_USERNAME`: meshdev
- `MQTT_PASSWORD`: large4cats
- `GROUPING_DURATION`: 10000 (message grouping delay in ms)
- `ENVIRONMENT`: production
- `REDIS_ENABLED`: false
- `REDIS_URL`: redis://localhost:6379

**CRITICAL**: The application does NOT automatically load .env files. Always use explicit environment variables or Docker Compose with env_file.

## Common Tasks

### Repository Structure
```
├── index.ts              # Main application entry point
├── src/
│   ├── FifoKeyCache.ts   # FIFO cache implementation
│   ├── MeshPacketQueue.ts # Message queuing and grouping
│   └── protobufs/        # Git submodule - Meshtastic protocol definitions
├── package.json          # Dependencies and scripts
├── Dockerfile            # Container build configuration
├── docker-compose.yml    # Multi-container deployment
├── .env.example          # Environment template
├── nodeDB.json           # Node database cache
└── ignoreDB.json         # Blocked nodes list
```

### Dependencies and Timing
- **npm install**: 4-20 seconds
- **Docker build**: 80-120 seconds first time
- **Docker Compose up**: 80-120 seconds first time, 3 seconds cached
- **App startup**: 2-3 seconds to initialize, then runs indefinitely
- **Submodule init**: 1-5 seconds

### Key Files to Check After Changes
- Always verify `index.ts` for MQTT connection logic
- Check `src/MeshPacketQueue.ts` for message processing changes
- Review `docker-compose.yml` for deployment configuration changes
- Update `.env.example` if adding new environment variables

## Build and Deployment Notes

### TypeScript Compilation
- **tsc check**: Has type errors but app runs correctly with tsx runtime
- **No build step required**: tsx handles TypeScript compilation at runtime
- **No output directory**: noEmit: true in tsconfig.json

### Docker Notes
- **Protobufs handling**: Dockerfile automatically clones protobufs if missing
- **Node.js version**: Uses Node.js 20 base image
- **Health check**: Built-in health check pings every 30 seconds
- **Data persistence**: Uses /app/data volume mount

### No Linting or Testing
- **No test suite**: package.json test script shows "no test specified"
- **No linting**: No ESLint, Prettier, or other linting tools configured
- **No formatting**: No automatic code formatting configured
- **No CI/CD**: No GitHub Actions workflows configured

## Troubleshooting

### Common Issues
- **"DISCORD_WEBHOOK_URL not set"**: App requires valid webhook URL to start
- **"ENOENT: no such file or directory, open '...protobufs...'"**: Run `git submodule update --init --recursive`
- **"Redis connection failed"**: Only occurs if REDIS_ENABLED=true without Redis running
- **TypeScript errors**: Normal - app uses tsx runtime, not tsc compilation

### Performance Expectations
- **NEVER CANCEL builds or long operations**
- **npm install**: 4-20 seconds
- **Docker build**: 80-120 seconds (set timeout to 180+ seconds)
- **Docker Compose**: 80-120 seconds first time
- **App startup**: Connects to MQTT and runs indefinitely

### Network Dependencies
- **MQTT broker**: Connects to mqtt.bayme.sh by default
- **Discord webhook**: Requires internet access for Discord API
- **Protobufs**: Requires git access to github.com/meshtastic/protobufs
- **Redis**: Optional, only if REDIS_ENABLED=true

## Manual Testing Commands

```bash
# Clean setup test
git clean -fd && git submodule update --init --recursive && npm install

# Development test  
DISCORD_WEBHOOK_URL=http://localhost:8080/test MQTT_TOPIC=msh/US/bayarea npm start

# Docker test
docker compose build && docker compose up -d && docker compose logs mesh-bot && docker compose down

# Redis test
docker compose --profile redis up -d && docker compose logs && docker compose down
```

## Architecture Notes

This is a **message bridge application** that:
- Connects to MQTT brokers to receive Meshtastic mesh network messages
- Decodes protobuf messages from mesh devices
- Groups and formats messages for Discord
- Forwards formatted messages to Discord webhooks
- Optionally uses Redis for persistent node database storage
- Supports multiple Discord webhooks for different regions (Bay Area, Sacramento Valley)