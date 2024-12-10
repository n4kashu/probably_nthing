# Installation Guide

## System Requirements

### Minimum Requirements
- Ubuntu 22.04 LTS
- 4 CPU cores
- 8GB RAM
- 20GB storage
- Root or sudo access

### Recommended Requirements
- 8+ CPU cores
- 16GB RAM
- 40GB SSD storage
- Dedicated server/VM

## Pre-Installation Steps

1. Update system packages:
```bash
sudo apt update && sudo apt upgrade -y
```

2. Clone the repository:
```bash
git clone https://github.com/n4kashu/probably_nthing.git
cd probably_nthing
```

3. Make scripts executable:
```bash
chmod +x scripts/*.sh
```

## Installation Process

1. Run the installation script:
```bash
sudo ./scripts/install-superagent.sh
```

2. Configure the environment:
```bash
sudo ./scripts/configure-env.sh
```

3. Configure your LLM providers in `/opt/superagent/superagent/libs/api/.env`

4. Start the services:
```bash
sudo ./scripts/manage-service.sh start
```

## Post-Installation

### Verify Installation
```bash
sudo ./scripts/manage-service.sh status
```

### View Logs
```bash
sudo ./scripts/manage-service.sh logs
```

### Create Backup
```bash
sudo ./scripts/manage-service.sh backup
```

## Configuration Guide

Detailed configuration options are available in the [CONFIGURATION.md](CONFIGURATION.md) file.

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.