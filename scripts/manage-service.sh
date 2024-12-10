#!/bin/bash

# Service Management Script for Superagent
# This script provides commands to manage the Superagent services

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*] $1${NC}"
}

# Function to print warnings
print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Function to print errors
print_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run as root or with sudo privileges"
    exit 1
fi

# Function to check service status
check_status() {
    print_status "Checking service status..."
    cd /opt/superagent/superagent
    docker-compose ps
}

# Function to start services
start_services() {
    print_status "Starting Superagent services..."
    cd /opt/superagent/superagent
    docker-compose up -d
}

# Function to stop services
stop_services() {
    print_warning "Stopping Superagent services..."
    cd /opt/superagent/superagent
    docker-compose down
}

# Function to restart services
restart_services() {
    print_status "Restarting Superagent services..."
    cd /opt/superagent/superagent
    docker-compose restart
}

# Function to view logs
view_logs() {
    print_status "Viewing logs..."
    cd /opt/superagent/superagent
    if [ -z "$1" ]; then
        docker-compose logs -f
    else
        docker-compose logs -f "$1"
    fi
}

# Function to create backup
create_backup() {
    print_status "Creating backup..."
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_DIR="/opt/superagent/backups"
    mkdir -p "$BACKUP_DIR"
    
    cd /opt/superagent/superagent
    docker-compose exec -T postgres pg_dump -U postgres superagent > "$BACKUP_DIR/superagent_${TIMESTAMP}.sql"
    
    # Backup environment files
    cp libs/api/.env "$BACKUP_DIR/api_env_${TIMESTAMP}"
    cp libs/ui/.env "$BACKUP_DIR/ui_env_${TIMESTAMP}"
    
    print_status "Backup created in $BACKUP_DIR"
}

# Display help message
show_help() {
    echo "Usage: $0 [command] [service]"
    echo ""
    echo "Commands:"
    echo "  start      Start all services"
    echo "  stop       Stop all services"
    echo "  restart    Restart all services"
    echo "  status     Show service status"
    echo "  logs       View logs (optionally specify service name)"
    echo "  backup     Create database and configuration backup"
    echo "  help       Show this help message"
}

# Main script logic
case "$1" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    status)
        check_status
        ;;
    logs)
        view_logs "$2"
        ;;
    backup)
        create_backup
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac

exit 0