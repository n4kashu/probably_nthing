#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

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

# Update system and install dependencies
print_status "Updating system and installing dependencies..."
apt update && apt upgrade -y
apt install -y git curl docker.io docker-compose

# Add current user to docker group
usermod -aG docker $SUDO_USER

# Create installation directory
print_status "Setting up Superagent..."
mkdir -p /opt/superagent
cd /opt/superagent

# Clone repository
git clone https://github.com/homanp/superagent.git .

# Create environment file
print_status "Creating environment file..."
cat > .env << EOL
# Authentication
JWT_SECRET=your-jwt-secret
SESSION_SECRET=your-session-secret

# LLM Providers
OPENAI_API_KEY=your-openai-api-key
# ANTHROPIC_API_KEY=your-anthropic-api-key
# AZURE_OPENAI_API_KEY=your-azure-openai-key

# Database
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/superagent
DATABASE_MIGRATION_URL=postgresql://postgres:postgres@postgres:5432/superagent

# Redis
REDIS_URL=redis://:redis@redis:6379

# Vector Store (optional)
# PINECONE_API_KEY=your-pinecone-api-key
# PINECONE_ENVIRONMENT=your-pinecone-environment

# Server
PORT=8000
ENVIRONMENT=development
EOL

print_status "Starting Superagent..."
docker-compose up -d

print_status "Installation complete!"
print_status "Access Superagent API at: http://localhost:8000"
print_status "Please update your environment variables in /opt/superagent/.env"
