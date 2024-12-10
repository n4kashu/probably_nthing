# Troubleshooting Guide

## Common Issues

### Installation Issues

#### Docker Installation Fails

Symptom:
```
Error: Package 'docker-ce' has no installation candidate
```

Solution:
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

#### Permission Denied

Symptom:
```
Permission denied while trying to connect to the Docker daemon socket
```

Solution:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Service Issues

#### Services Won't Start

1. Check logs:
```bash
sudo ./scripts/manage-service.sh logs
```

2. Verify Docker service:
```bash
sudo systemctl status docker
```

3. Check port availability:
```bash
sudo netstat -tulpn | grep -E '3000|3001'
```

#### Database Connection Issues

Symptom: API can't connect to PostgreSQL

Troubleshooting steps:
1. Check PostgreSQL logs:
```bash
sudo docker-compose logs postgres
```

2. Verify DATABASE_URL in .env
3. Check PostgreSQL container status

### Memory Issues

Symptom: Services crashing or unstable

Solution:
1. Check memory usage:
```bash
free -h
```

2. Monitor container resources:
```bash
docker stats
```

3. Adjust container memory limits in docker-compose.override.yml

## Performance Optimization

### Slow Response Times

1. Check system resources:
```bash
top
iotop
```

2. Monitor API response times:
```bash
sudo docker-compose logs api | grep "Response time"
```

3. Check Redis performance:
```bash
redis-cli --stat
```

### High CPU Usage

1. Identify heavy processes:
```bash
top -o %CPU
```

2. Monitor container CPU usage:
```bash
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

## Recovery Procedures

### Database Recovery

1. Stop services:
```bash
sudo ./scripts/manage-service.sh stop
```

2. Restore from backup:
```bash
cat /opt/superagent/backups/superagent_TIMESTAMP.sql | docker-compose exec -T postgres psql -U postgres superagent
```

### Service Recovery

1. Full service restart:
```bash
sudo ./scripts/manage-service.sh restart
```

2. Individual service restart:
```bash
docker-compose restart service_name
```

## Debug Mode

Enable debug logging:

1. Modify API environment:
```env
LOG_LEVEL=debug
```

2. Restart services:
```bash
sudo ./scripts/manage-service.sh restart
```

## Support Information

### Log Collection

Collect all logs for support:
```bash
sudo ./scripts/manage-service.sh logs > system_logs.txt
```

### System Information

Gather system info:
```bash
uname -a
docker version
docker-compose version
```