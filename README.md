# Rage Against The Mesh(ine)

A portable Discord bot for Meshtastic mesh networks that bridges MQTT messages to Discord webhooks. This bot can be easily deployed in any region or community with minimal configuration.

## Features

- 🌐 **Portable**: Works with any Meshtastic MQTT topic/region
- 🐳 **Docker Ready**: Complete Docker Compose setup for easy deployment
- 🔧 **Configurable**: All settings via environment variables
- 📱 **Discord Integration**: Rich embed messages with node information
- 🔄 **Redis Support**: Optional caching for better performance
- 🔒 **Secure**: Non-root Docker container with proper signal handling
- 📊 **Monitoring**: Sentry integration for error tracking

## Quick Start

### Prerequisites

- Docker and Docker Compose
- A Discord webhook URL
- Access to a Meshtastic MQTT broker

### 1. Clone the Repository

```bash
git clone https://github.com/roperscrossroads/ratm-meshtastic-discord-bot.git
cd ratm-meshtastic-discord-bot
```

### 2. Configure Environment

```bash
cp .env.example .env
```

Edit `.env` and set your configuration:

```bash
# REQUIRED: Your Discord webhook URL
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN

# REQUIRED: The MQTT topic to monitor (e.g., "msh/US/bayarea", "msh/US/seattle")
MQTT_TOPIC=msh/US/YOUR_REGION

# OPTIONAL: MQTT broker (defaults to mqtt://mqtt.bayme.sh)
MQTT_BROKER_URL=mqtt://mqtt.bayme.sh
```

### 3. Deploy with Docker Compose

```bash
docker compose up -d
```

### 4. View Logs

```bash
docker compose logs -f ratm-bot
```

## Environment Variables

### Required Configuration

| Variable | Description | Example |
|----------|-------------|---------|
| `DISCORD_WEBHOOK_URL` | Discord webhook URL for messages | `https://discord.com/api/webhooks/123/abc` |
| `MQTT_TOPIC` | MQTT topic to monitor | `msh/US/bayarea` |

### Optional Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `MQTT_BROKER_URL` | MQTT broker URL | `mqtt://mqtt.bayme.sh` |
| `ENVIRONMENT` | Environment name | `production` |
| `GROUPING_DURATION` | Message grouping time (ms) | `10000` |
| `REDIS_ENABLED` | Enable Redis caching | `false` |
| `REDIS_URL` | Redis connection URL | `redis://redis:6379` |
| `PFP_JSON_URL` | Profile picture mapping URL | _(none)_ |
| `RBL_JSON_URL` | Ignore list URL | _(none)_ |
| `SENTRY_DSN` | Sentry error tracking DSN | _(none)_ |

## Discord Webhook Setup

1. Go to your Discord server settings
2. Navigate to **Integrations** → **Webhooks**
3. Click **New Webhook**
4. Configure the webhook:
   - Name: `Meshtastic Bot`
   - Channel: Select your desired channel
5. Copy the webhook URL and use it for `DISCORD_WEBHOOK_URL`

## Deployment Options

### Docker Compose (Recommended)

The easiest way to deploy with optional Redis support:

```bash
# Start with Redis
docker compose up -d

# Start without Redis (set REDIS_ENABLED=false in .env)
docker compose up -d ratm-bot
```

### Docker Only

```bash
# Build the image
docker build -t ratm-bot .

# Run the container
docker run -d \
  --name ratm-bot \
  -e DISCORD_WEBHOOK_URL="your_webhook_url" \
  -e MQTT_TOPIC="msh/US/your_region" \
  ratm-bot
```

### Direct Node.js

```bash
# Install dependencies
npm install

# Set environment variables
export DISCORD_WEBHOOK_URL="your_webhook_url"
export MQTT_TOPIC="msh/US/your_region"

# Run the bot
npm start
```

## Configuration Examples

### Bay Area Mesh

```bash
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/123/abc
MQTT_TOPIC=msh/US/bayarea
MQTT_BROKER_URL=mqtt://mqtt.bayme.sh
```

### Seattle Mesh

```bash
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/456/def
MQTT_TOPIC=msh/US/seattle
MQTT_BROKER_URL=mqtt://mqtt.meshtastic.org
```

### Custom Region

```bash
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/789/ghi
MQTT_TOPIC=msh/EU/london
MQTT_BROKER_URL=mqtt://your-custom-broker.com
```

## Features Details

### Message Processing

- **Text Messages**: Displays sender, message content, packet info, and gateway details
- **Node Information**: Shows node names, hardware info, and battery status
- **Signal Quality**: Displays SNR, RSSI, and hop information
- **Timestamps**: All messages include receive timestamps

### Redis Caching

When enabled, Redis provides:
- Node information caching
- Reduced MQTT broker load
- Persistent node database
- Multi-instance coordination

### Profile Pictures

Configure custom profile pictures by providing a JSON URL:

```json
{
  "default": "https://example.com/default-avatar.png",
  "fa6dc348": "https://example.com/node-avatar.png"
}
```

## Troubleshooting

### Bot Not Receiving Messages

1. **Check MQTT Topic**: Ensure `MQTT_TOPIC` matches your mesh network
2. **Verify Broker**: Confirm `MQTT_BROKER_URL` is accessible
3. **Check Logs**: `docker compose logs -f ratm-bot`

### Discord Messages Not Appearing

1. **Test Webhook**: Send a test message to your webhook URL
2. **Check Permissions**: Ensure bot has permission to send messages
3. **Verify URL**: Confirm `DISCORD_WEBHOOK_URL` is correct

### Redis Connection Issues

1. **Check Redis Service**: `docker compose ps redis`
2. **Verify Connection**: Ensure `REDIS_URL` is correct
3. **Disable if Needed**: Set `REDIS_ENABLED=false`

## Development

### Local Development

```bash
# Install dependencies
npm install

# Clone protobufs
git clone https://github.com/meshtastic/protobufs.git src/protobufs

# Set environment variables
cp .env.example .env
# Edit .env with your settings

# Run in development mode
npm run dev
```

### Available Scripts

- `npm start`: Start the bot
- `npm run dev`: Start with file watching
- `npm run build`: Build Docker image
- `npm run compose:up`: Start with Docker Compose
- `npm run compose:down`: Stop Docker Compose
- `npm run compose:logs`: View logs

## Migration from Multi-Region Bot

If migrating from the original Bay Area/Sacramento Valley bot:

1. Set `MQTT_TOPIC` to your desired topic (e.g., `msh/US/bayarea`)
2. Set `DISCORD_WEBHOOK_URL` to your primary webhook
3. Remove these old environment variables:
   - `SV_DISCORD_WEBHOOK_URL`
   - `DISCORD_MS_WEBOOK_URL`
4. Deploy with `docker compose up -d`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

ISC License

## Acknowledgments

This bot builds upon the excellent work of the original authors who created the foundational MQTT-to-Discord bridge functionality. Special thanks to the Bay Area mesh community for the original implementation that inspired this portable version.
