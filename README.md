# Rage Against The Mesh(ine)

A portable Discord bot for Meshtastic networks that listens to MQTT topics and forwards messages to Discord webhooks.

## 🚀 Quick Start

Get up and running in under 2 minutes:

1. **Clone the repository**
   ```bash
   git clone https://github.com/roperscrossroads/ratm-meshtastic-discord-bot.git
   cd ratm-meshtastic-discord-bot
   ```

2. **Configure your environment**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and set your Discord webhook URL and MQTT topic:
   ```bash
   DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN
   MQTT_TOPIC=msh/US/bayarea
   ```

3. **Start the bot**
   ```bash
   docker compose up -d
   ```

That's it! Your bot is now listening to your MQTT topic and forwarding messages to Discord.

## 📋 Requirements

- Docker and Docker Compose
- A Discord webhook URL ([How to get one](#how-to-get-a-discord-webhook))
- Access to a Meshtastic MQTT broker

## ⚙️ Configuration

### Required Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `DISCORD_WEBHOOK_URL` | Discord webhook URL for message forwarding | `https://discord.com/api/webhooks/123.../abc...` |
| `MQTT_TOPIC` | MQTT topic to listen to | `msh/US/bayarea` |

### Optional Environment Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `MQTT_BROKER_URL` | MQTT broker URL | `mqtt://mqtt.bayme.sh` | `mqtt://mqtt.meshtastic.org` |
| `MQTT_USERNAME` | MQTT broker username | `meshdev` | `your_username` |
| `MQTT_PASSWORD` | MQTT broker password | `large4cats` | `your_password` |
| `GROUPING_DURATION` | Message grouping delay (ms) | `10000` | `5000` |
| `ENVIRONMENT` | Runtime environment | `production` | `development` |
| `SV_DISCORD_WEBHOOK_URL` | Additional webhook for Sacramento Valley messages | - | Same format as main webhook |
| `REDIS_ENABLED` | Enable Redis for persistent storage | `false` | `true` |
| `REDIS_URL` | Redis connection URL | `redis://localhost:6379` | `redis://user:pass@host:port` |
| `PFP_JSON_URL` | URL for profile picture mappings | - | `https://example.com/pfp.json` |
| `RBL_JSON_URL` | URL for blocked node list | - | `https://example.com/blocklist.json` |

### Using Redis (Optional)

To enable persistent node database storage with Redis:

1. **Enable Redis profile**:
   ```bash
   docker compose --profile redis up -d
   ```

2. **Set Redis environment variables** in your `.env`:
   ```bash
   REDIS_ENABLED=true
   REDIS_URL=redis://ratm-redis:6379
   ```

## 🔧 Advanced Usage

### Custom MQTT Broker

To use a different MQTT broker, update your `.env`:
```bash
MQTT_BROKER_URL=mqtt://your-broker.example.com
MQTT_USERNAME=your_username
MQTT_PASSWORD=your_password
```

### Multiple Webhooks

The bot supports multiple Discord webhooks for different regions:
- `DISCORD_WEBHOOK_URL`: Primary webhook (Bay Area topics)
- `SV_DISCORD_WEBHOOK_URL`: Sacramento Valley topics

### Development Mode

For development with live reload:
```bash
npm install
npm start
```

## 🩺 Troubleshooting

### Bot won't start
- **Check your environment variables**: Ensure `DISCORD_WEBHOOK_URL` is set correctly
- **Verify Docker is running**: `docker --version`
- **Check logs**: `docker compose logs mesh-bot`

### No messages in Discord
- **Verify webhook URL**: Test it with a curl command
- **Check MQTT topic**: Ensure your topic matches actual mesh traffic
- **Review logs**: `docker compose logs mesh-bot -f`

### Connection issues
- **MQTT broker connectivity**: Check if the broker is accessible
- **Network issues**: Verify Docker networking with `docker network ls`

### Common Error Messages

| Error | Solution |
|-------|----------|
| `DISCORD_WEBHOOK_URL not set` | Set the webhook URL in your `.env` file |
| `ENOENT: no such file or directory, open '...protobufs...'` | The protobufs are cloned during Docker build automatically |
| `Redis connection failed` | Check Redis is running if `REDIS_ENABLED=true` |

## 📊 Logs

View real-time logs:
```bash
# All services
docker compose logs -f

# Just the bot
docker compose logs mesh-bot -f

# With timestamps
docker compose logs mesh-bot -f -t
```

## 🔗 How to Get a Discord Webhook

1. **Open your Discord server** and go to the channel where you want messages
2. **Click the gear icon** (Edit Channel) next to the channel name
3. **Navigate to "Integrations"** in the left sidebar
4. **Click "Webhooks"** then **"New Webhook"**
5. **Customize the webhook** (name, avatar, channel)
6. **Copy the Webhook URL** - this is your `DISCORD_WEBHOOK_URL`

The URL format is: `https://discord.com/api/webhooks/{webhook.id}/{webhook.token}`

## 🛑 Stopping the Bot

```bash
# Stop the bot
docker compose down

# Stop and remove all data
docker compose down -v
```

## 🔄 Updates

To update to the latest version:
```bash
git pull
docker compose build --no-cache
docker compose up -d
```

## 🙏 Acknowledgments

**This project builds upon the foundational work of the original authors and the Bay Area mesh community.** Special thanks to:

- **Original RATM codebase creators** for building the initial Discord bot framework
- **Bay Area Mesh Community** for their continued development and testing of mesh networking infrastructure
- **Meshtastic project** for providing the excellent mesh networking platform
- **All contributors** who have helped improve and maintain this codebase

This portable version maintains the core functionality while making deployment easier for mesh communities worldwide.

## 📈 Architecture

The bot operates as a simple but effective bridge:

1. **Connects** to a Meshtastic MQTT broker
2. **Listens** to specified MQTT topics for mesh traffic
3. **Processes** and groups related messages
4. **Forwards** formatted messages to Discord via webhooks

**Key Features:**
- ✅ Portable: Single MQTT topic → Single Discord webhook
- ✅ Docker-first deployment
- ✅ Optional Redis for persistence
- ✅ Configurable message grouping
- ✅ Support for multiple regions
- ✅ Profile picture integration
- ✅ Node blocking/filtering

## 📄 License

ISC License - see the original project for details.
