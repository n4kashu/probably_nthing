#!/bin/bash

# Environment Configuration Script for Superagent
# This script should be run after the installation script

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*] $1${NC}"
}

# Function to generate random string
generate_random_string() {
    openssl rand -hex 16
}

# Configuration variables
DB_PASSWORD=$(generate_random_string)
REDIS_PASSWORD=$(generate_random_string)
JWT_SECRET=$(generate_random_string)

# Configure API environment
cat > /opt/superagent/superagent/libs/api/.env << EOL
# Database configuration
DATABASE_URL=postgresql://postgres:${DB_PASSWORD}@postgres:5432/superagent
REDIS_URL=redis://:${REDIS_PASSWORD}@redis:6379

# Security
JWT_SECRET=${JWT_SECRET}

# LLM Provider (uncomment and configure one)
OPENAI_API_KEY=your_openai_api_key
#ANTHROPIC_API_KEY=your_anthropic_api_key
#AZURE_OPENAI_API_KEY=your_azure_openai_api_key

# Optional configurations
PORT=3000
NODE_ENV=production
CORS_ORIGIN=*

# Vector database (optional)
#PINECONE_API_KEY=your_pinecone_api_key
#PINECONE_ENVIRONMENT=your_pinecone_environment

# Document processing (optional)
#OCR_API_KEY=your_ocr_api_key
EOL

# Configure UI environment
cat > /opt/superagent/superagent/libs/ui/.env << EOL
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_APP_URL=http://localhost:3001

# OAuth configuration (optional)
#GITHUB_CLIENT_ID=your_github_client_id
#GITHUB_CLIENT_SECRET=your_github_client_secret
EOL

# Create Docker Compose override file
cat > /opt/superagent/superagent/docker-compose.override.yml << EOL
version: '3.8'

services:
  postgres:
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data

  api:
    environment:
      NODE_ENV: production
    restart: always

  ui:
    environment:
      NODE_ENV: production
    restart: always

volumes:
  postgres_data:
  redis_data:
EOL

# Set proper permissions
chmod 600 /opt/superagent/superagent/libs/api/.env
chmod 600 /opt/superagent/superagent/libs/ui/.env

print_status "Environment configuration completed!"
print_status "Generated passwords:"
echo "Database password: ${DB_PASSWORD}"
echo "Redis password: ${REDIS_PASSWORD}"
echo "JWT secret: ${JWT_SECRET}"
print_status "Please update the LLM provider API keys and other optional configurations in the .env files"