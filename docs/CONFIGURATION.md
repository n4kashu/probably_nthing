# Configuration Guide

## Environment Variables

### API Configuration

Location: `/opt/superagent/superagent/libs/api/.env`

#### Database Settings
```env
DATABASE_URL=postgresql://postgres:password@postgres:5432/superagent
REDIS_URL=redis://:password@redis:6379
```

#### LLM Provider Settings
```env
OPENAI_API_KEY=your_openai_api_key
ANTHROPIC_API_KEY=your_anthropic_api_key
AZURE_OPENAI_API_KEY=your_azure_openai_api_key
```

#### Security Settings
```env
JWT_SECRET=your_jwt_secret
CORS_ORIGIN=*
```

### UI Configuration

Location: `/opt/superagent/superagent/libs/ui/.env`

```env
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_APP_URL=http://localhost:3001
```

## Docker Configuration

### Volume Management

Default volumes:
- `postgres_data`: PostgreSQL data
- `redis_data`: Redis data

### Network Configuration

Default ports:
- API: 3000
- UI: 3001
- PostgreSQL: 5432 (internal)
- Redis: 6379 (internal)

## Security Configuration

### File Permissions

Critical files should have restricted permissions:
```bash
chmod 600 /opt/superagent/superagent/libs/api/.env
chmod 600 /opt/superagent/superagent/libs/ui/.env
```

### Firewall Configuration

Example UFW rules:
```bash
ufw allow 3000/tcp
ufw allow 3001/tcp
```

## Maintenance

### Backup Configuration

Backups are stored in `/opt/superagent/backups`

Customize backup location in `manage-service.sh`:
```bash
BACKUP_DIR="/path/to/backup/location"
```

### Logging Configuration

Default logging settings:
```env
LOG_LEVEL=info
LOG_FORMAT=json
```

## Advanced Configuration

### Rate Limiting

Configure in API environment:
```env
RATE_LIMIT_WINDOW=15m
RATE_LIMIT_MAX=100
```

### Caching

Redis cache settings:
```env
CACHE_TTL=3600
```