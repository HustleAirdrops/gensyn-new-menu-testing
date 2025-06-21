#!/bin/bash -x

# Colors
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

# Log file
LOG_FILE="$HOME/setup.log"
echo "Starting setup at $(date)" > "$LOG_FILE"

# Arguments
USE_LATEST="$1"
BACKUP_PEM="$2"

# Function to log and print messages
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

# Trap errors and log them
trap 'log "${RED}❌ Error on line $LINENO: $BASH_COMMAND${NC}"; exit 1' ERR

# -------------------------------------
# 🔍 Check for Existing Installation
# -------------------------------------
FOLDER="rl-swarm"
if [ -d "$FOLDER" ]; then
    log "${YELLOW}⚠️ Existing installation found at $FOLDER${NC}"
    read -p "👉 Do you want to proceed with reinstallation? [y/N]: " reinstall_choice
    if [[ "$reinstall_choice" != "y" && "$reinstall_choice" != "Y" ]]; then
        log "${RED}❌ Installation aborted.${NC}"
        exit 1
    fi
fi

# -------------------------------------
# 🛠 System Setup
# -------------------------------------
log "${YELLOW}📥 Installing required packages...${NC}"
sudo apt update >> "$LOG_FILE" 2>&1
sudo apt install -y \
    python3 python3-venv python3-pip \
    curl wget screen git lsof \
    nodejs ufw yarn >> "$LOG_FILE" 2>&1

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >> "$LOG_FILE" 2>&1
sudo apt update >> "$LOG_FILE" 2>&1
sudo apt install -y nodejs >> "$LOG_FILE" 2>&1

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - >> "$LOG_FILE" 2>&1
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list > /dev/null
sudo apt update >> "$LOG_FILE" 2>&1
sudo apt install -y yarn >> "$LOG_FILE" 2>&1

sudo apt install -y ufw >> "$LOG_FILE" 2>&1
sudo ufw allow 22 >> "$LOG_FILE" 2>&1
sudo ufw allow 3000/tcp >> "$LOG_FILE" 2>&1
sudo ufw --force enable >> "$LOG_FILE" 2>&1

wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb >> "$LOG_FILE" 2>&1
sudo dpkg -i cloudflared-linux-amd64.deb >> "$LOG_FILE" 2>&1 || sudo apt --fix-broken install -y >> "$LOG_FILE" 2>&1

log "${GREEN}✅ Basic system setup complete.${NC}"

# -------------------------------------
# 🔁 Prepare for Repository Setup
# -------------------------------------
cd ~ || { log "${RED}❌ Failed to go to home directory${NC}"; exit 1; }

REPO_URL="https://github.com/gensyn-ai/rl-swarm.git"
DOWNGRADED_COMMIT="385e0b345aaa7a0a580cbec24aa4dbdb9dbd4642"

BACKUP_DIR="$HOME/swarm_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/swarm_backup_$TIMESTAMP.pem"
SAFE_FILE="$HOME/swarm.pem"

mkdir -p "$BACKUP_DIR" >> "$LOG_FILE" 2>&1

# -------------------------------------
# 🛡 Backup Existing PEM
# -------------------------------------
if [ "$BACKUP_PEM" = true ]; then
    log "${YELLOW}🔒 Backing up existing swarm.pem...${NC}"
    sudo cp "$FOLDER/swarm.pem" "$SAFE_FILE" >> "$LOG_FILE" 2>&1
    sudo cp "$FOLDER/swarm.pem" "$BACKUP_FILE" >> "$LOG_FILE" 2>&1
    sudo chown $(whoami):$(whoami) "$SAFE_FILE" "$BACKUP_FILE" >> "$LOG_FILE" 2>&1
    log "${GREEN}✅ Backup complete.${NC}"
else
    log "${YELLOW}🆕 Skipping PEM backup as per your choice.${NC}"
fi

# -------------------------------------
# 📦 Clone & Checkout
# -------------------------------------
log "${YELLOW}📁 Cloning RL-Swarm repo...${NC}"
rm -rf "$FOLDER" >> "$LOG_FILE" 2>&1
git clone "$REPO_URL" >> "$LOG_FILE" 2>&1
cd "$FOLDER" >> "$LOG_FILE" 2>&1

if [ "$USE_LATEST" = false ]; then
    log "${YELLOW}⏳ Switching to stable commit...${NC}"
    git checkout "$DOWNGRADED_COMMIT" >> "$LOG_FILE" 2>&1
fi

# -------------------------------------
# 🛠 Apply Fixes
# -------------------------------------
log "${YELLOW}🛠 Applying fixes from fixall.sh...${NC}"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hustleairdrops/Gensyn-Advanced-Solutions/main/fixall.sh)" >> "$LOG_FILE" 2>&1 || {
    log "${YELLOW}⚠️ Some fixes may have failed. Check $LOG_FILE for details. Continuing setup...${NC}"
}

log "${GREEN}✅ Fixes applied.${NC}"

# -------------------------------------
# 🔐 Restore PEM
# -------------------------------------
if [ "$BACKUP_PEM" = true ] && [ -f "$SAFE_FILE" ]; then
    cp "$SAFE_FILE" swarm.pem >> "$LOG_FILE" 2>&1
    log "${GREEN}✅ PEM restored.${NC}"
else
    log "${YELLOW}⚠️ No PEM backup to restore. Continuing setup.${NC}"
fi

# -------------------------------------
# 📦 Install modal-login dependencies (only for downgraded)
# -------------------------------------
if [ "$USE_LATEST" = false ]; then
    log "${YELLOW}📦 Installing modal-login packages...${NC}"
    cd modal-login >> "$LOG_FILE" 2>&1
    yarn install >> "$LOG_FILE" 2>&1
    yarn upgrade >> "$LOG_FILE" 2>&1
    yarn add next@latest viem@latest >> "$LOG_FILE" 2>&1
    log "${GREEN}✅ modal-login setup complete.${NC}"
    cd .. >> "$LOG_FILE" 2>&1
fi

# -------------------------------------
# ✅ Final Message
# -------------------------------------
cd ~ >> "$LOG_FILE" 2>&1
clear
log "${GREEN}🏁 Setup complete! '${FOLDER}' is ready to run.${NC}"
log "🔗 Telegram: ${YELLOW}@Hustle_Airdrops${NC}"
log "📺 Join the community & stay updated!"
log "${YELLOW}🎯 Next time to run: cd rl-swarm && ./run_rl_swarm.sh${NC}"
log "${GREEN}💎 Powered by Hustle Airdrops – Let’s Win Together! 🚀${NC}"
