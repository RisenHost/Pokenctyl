#!/usr/bin/env bash
# Pokenctyl one-command installer v1.0
# © Pokenctyl 2025-26
set -euo pipefail

REPO_URL="https://github.com/REPLACE_WITH_YOUR_USER/Pokenctyl.git"
BRANCH="main"
INSTALL_DIR="/opt/pokenctyl"

echo -e "\n\e[96m🚀 Pokenctyl Installer — Starting\e[0m"

# Basic checks
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root: sudo bash pokenctyl.sh"
  exit 1
fi

# Update & install deps
apt update && apt upgrade -y
apt install -y git curl wget unzip git docker.io docker-compose nodejs npm build-essential jq nginx

# Clone repo
if [ -d "$INSTALL_DIR" ]; then
  echo "Found existing install at $INSTALL_DIR — pulling latest"
  cd "$INSTALL_DIR" && git pull origin "$BRANCH"
else
  git clone --depth=1 -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

# Create .env (simple defaults)
cat > .env <<EOF
# Pokenctyl environment
PANEL_PORT=8080
DB_HOST=db
DB_USER=pokenctyl
DB_PASS=pokenctyl123
DB_NAME=pokenctyl
DAEMON_TOKEN=$(head -c 24 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 32)
EOF

# Start services with docker-compose (frontend, backend, db, nginx)
if [ -f docker-compose.yml ]; then
  docker compose up -d --build
else
  echo "Warning: docker-compose.yml not found in repo. Skipping docker compose step."
fi

# Register local daemon (simple loopback registration)
DAEMON_TOKEN=$(cat .env | grep DAEMON_TOKEN | cut -d '=' -f2)
if [ -f daemon/daemon.js ]; then
  docker build -t pokenctyl/daemon:latest daemon/
  docker run -d --name pokenctyl-daemon --restart unless-stopped \\
    -e PANEL_URL="http://localhost:8080/api" -e DAEMON_TOKEN="$DAEMON_TOKEN" \\
    --network host pokenctyl/daemon:latest
fi

# Print access details
IP=$(hostname -I | awk '{print $1}')
PANEL_PORT=$(grep PANEL_PORT .env | cut -d '=' -f2)

echo -e "\n\e[92m✅ Pokenctyl installed!\e[0m"
echo -e "Open: http://$IP:$PANEL_PORT"
echo -e "Admin default login: admin@pokenctyl.local / Password: P0kenAdmin! (change ASAP)"

# Friendly ending
echo -e "\nIf anything is missing tell me and I'll fix it. — Pokenctyl AI helper 💖"
