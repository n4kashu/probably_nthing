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
apt install -y git python3-pip python3-venv

# Create installation directory
print_status "Creating installation directory..."
mkdir -p /opt/superagent
cd /opt/superagent

# Create and activate virtual environment
print_status "Setting up Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# Install Superagent
print_status "Installing Superagent..."
pip install superagent

# Optional: Install development version from GitHub
#git clone https://github.com/superagent-ai/superagent.git
#cd superagent
#pip install -e .

print_status "Installation completed!"
print_status "You can now use Superagent by activating the virtual environment:"
echo "cd /opt/superagent"
echo "source venv/bin/activate"
