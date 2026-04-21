#!/bin/bash

clear
echo "======================================="
echo "   O3DN Browser VPS Installer 🚀"
echo "======================================="

# Ask browser choice
echo ""
echo "Select browser to install:"
echo "1) Chromium"
echo "2) Brave"
read -p "Enter choice (1 or 2): " choice

# Install Docker if not installed
if ! command -v docker &> /dev/null
then
    echo "[+] Installing Docker..."
    curl -fsSL https://get.docker.com | sh
fi

# Stop old container if exists
docker rm -f browser 2>/dev/null

# Ask credentials
read -p "Enter username: " USERNAME
read -p "Enter password: " PASSWORD

# Timezone auto detect (fallback)
TZ=$(timedatectl | grep "Time zone" | awk '{print $3}')
TZ=${TZ:-Etc/UTC}

# Choose image
if [ "$choice" == "1" ]; then
    IMAGE="lscr.io/linuxserver/chromium:latest"
    NAME="Chromium"
elif [ "$choice" == "2" ]; then
    IMAGE="lscr.io/linuxserver/brave:latest"
    NAME="Brave"
else
    echo "Invalid choice!"
    exit 1
fi

echo "[+] Installing $NAME browser..."

docker run -d \
  --name=browser \
  --security-opt seccomp=unconfined \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=$TZ \
  -e CUSTOM_USER=$USERNAME \
  -e PASSWORD=$PASSWORD \
  -p 3000:3000 \
  -p 3001:3001 \
  --shm-size="2gb" \
  --restart unless-stopped \
  $IMAGE

IP=$(curl -s ifconfig.me)

echo ""
echo "======================================="
echo "✅ Installation Complete!"
echo "======================================="
echo "🌐 Access your browser:"
echo "https://$IP:3001"
echo ""
echo "⚠️ Accept SSL warning in browser"
echo "======================================="
