#!/bin/bash

# Superagent Installation Script for Ubuntu 22.04
# This script should be run as root or with sudo privileges

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Error handling
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "\"${last_command}\" command failed with exit code $?."' EXIT

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*] $1${NC}"
}

# Function to print warnings
print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root or with sudo privileges"
    exit 1
fi

# Update system
print_status "Updating system packages..."
apt update && apt upgrade -y

# Install essential packages
print_status "Installing essential packages..."
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    git \
    make \
    build-essential

# Install Docker
print_status "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker $SUDO_USER
    systemctl enable docker
    systemctl start docker
else
    print_warning "Docker already installed, skipping..."
fi

# Install Docker Compose
print_status "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
else
    print_warning "Docker Compose already installed, skipping..."
fi

# Create directory structure
print_status "Creating directory structure..."
mkdir -p /opt/superagent
cd /opt/superagent

# Clone Superagent repository
print_status "Cloning Superagent repository..."
if [ ! -d "/opt/superagent/superagent" ]; then
    git clone https://github.com/superagent-ai/superagent.git
    cd superagent
else
    print_warning "Superagent repository already exists, updating..."
    cd superagent
    git pull
fi

# Create environment files from templates
print_status "Setting up environment files..."

# Create API environment file
cat > libs/api/.env << EOL
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/superagent
REDIS_URL=redis://:redis@redis:6379

# Security
JWT_SECRET=your-jwt-secret

# LLM Provider (uncomment and configure one)
OPENAI_API_KEY=your_openai_api_key
#ANTHROPIC_API_KEY=your_anthropic_api_key
#AZURE_OPENAI_API_KEY=your_azure_openai_api_key

# Server Configuration
PORT=3000
NODE_ENV=production
CORS_ORIGIN=*
EOL

# Create UI environment file
cat > libs/ui/.env << EOL
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_APP_URL=http://localhost:3001
EOL

# Set proper permissions
chmod 600 libs/api/.env libs/ui/.env

print_status "Installation completed successfully!"
print_status "Please configure your environment variables in:"
print_status "- /opt/superagent/superagent/libs/api/.env"
print_status "- /opt/superagent/superagent/libs/ui/.env"

# Remove error handling trap
trap - EXIT