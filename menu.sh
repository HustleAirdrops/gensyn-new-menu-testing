#!/bin/bash

# Colors
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

# Function to display main menu
display_main_menu() {
    clear
    echo -e "${YELLOW}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║                                              ║"
    echo "║   🚀 HUSTLE AIRDROPS SYSTEM SETUP TOOL       ║"
    echo "║                                              ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "📢 Telegram: ${GREEN}@Hustle_Airdrops${NC}"
    echo "=================================================="
    echo -e "${YELLOW}🌀 Hustle Airdrops - Setup Menu${NC}"
    echo "=================================================="
    echo "1️⃣  🛠 Install/Reinstall Node"
    echo "=================================================="
    read -p "👉 Enter your choice [1]: " choice
    if [[ "$choice" != "1" ]]; then
        echo -e "${RED}❌ Invalid choice. Exiting...${NC}"
        exit 1
    fi
    display_version_menu
}

# Function to display version sub-menu
display_version_menu() {
    clear
    echo -e "${YELLOW}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║                                              ║"
    echo "║   🚀 H USTLE AIRDROPS SYSTEM SETUP TOOL       ║"
    echo "║                                              ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "📢 Telegram: ${GREEN}@Hustle_Airdrops${NC}"
    echo "=================================================="
    echo -e "${YELLOW}🌀 Select Version${NC}"
    echo "=================================================="
    echo "1️⃣  Setup with LATEST version"
    echo "2️⃣  Setup with DOWNGRADED version (recommended)"
    echo "=================================================="
    read -p "👉 Enter your choice [1/2]: " version_choice
    if [[ "$version_choice" == "1" ]]; then
        USE_LATEST=true
    elif [[ "$version_choice" == "2" ]]; then
        USE_LATEST=false
    else
        echo -e "${RED}❌ Invalid choice. Exiting...${NC}"
        exit 1
    fi
    ask_pem_backup
}

# Function to ask about PEM backup
ask_pem_backup() {
    FOLDER="rl-swarm"
    BACKUP_PEM=false
    if [ -f "$FOLDER/swarm.pem" ]; then
        clear
        echo -e "${YELLOW}"
        echo "╔══════════════════════════════════════════════╗"
        echo "║                                              ║"
        echo "║   🚀 HU STLE AIRDROPS SYSTEM SETUP TOOL       ║"
        echo "║                                              ║"
        echo "╚══════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo -e "📢 Telegram: ${GREEN}@Hustle_Airdrops${NC}"
        echo "=================================================="
        echo -e "${YELLOW}🔒 swarm.pem found. Do you want to back it up?${NC}"
        echo "=================================================="
        read -p "👉 Enter your choice [y/N]: " pem_choice
        if [[ "$pem_choice" == "y" || "$pem_choice" == "Y" ]]; then
            BACKUP_PEM=true
        fi
    fi
    # Download and execute remote setup.sh
    echo -e "${YELLOW}📥 Downloading setup script...${NC}"
    SETUP_URL="https://raw.githubusercontent.com/HustleAirdrops/gensyn-new-menu-testing/main/setup.sh"
    TEMP_SCRIPT="/tmp/setup.sh"
    curl -fsSL "$SETUP_URL" -o "$TEMP_SCRIPT" || {
        echo -e "${RED}❌ Failed to download setup.sh from $SETUP_URL${NC}"
        exit 1
    }
    chmod +x "$TEMP_SCRIPT"
    bash "$TEMP_SCRIPT" "$USE_LATEST" "$BACKUP_PEM"
    rm -f "$TEMP_SCRIPT"
}

# Start with main menu
display_main_menu
