#!/bin/bash

clear

echo "======================================="
echo "   O3DN Browser VPS Installer 🚀"
echo "======================================="

# Root check
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root"
  exit 1
fi

# Install Docker if not installed
if ! command -v docker &> /dev/null
then
    echo "[+] Installing Docker..."
    curl -fsSL https://get.docker.com | sh
else
    echo "[✓] Docker already installed"
fi

# Remove old container
docker rm -f browser 2>/dev/null

# Browser selection (FIXED INPUT)
echo ""
echo "Select browser to install:"
echo "1) Chromium"
echo "2) Brave"
echo "3) Firefox"

while true; do
  read -p "Enter choice (1/2/3): " choice
  case $choice in
    1)
      IMAGE="lscr.io/linuxserver/chromium:latest"
      NAME="Chromium"
      break
      ;;
    2)
      IMAGE="lscr.io/linuxserver/brave:latest"
      NAME="Brave"
      break
      ;;
    3)
      IMAGE="lscr.io/linuxserver/firefox:latest"
      NAME="Firefox"
      break
      ;;
    *)
      echo "❌ Invalid choice. Try again."
      ;;
  esac
done

# Credentials input
echo ""
read -p "Enter username: " USERNAME
read -s -p "Enter password: " PASSWORD
echo ""

# Timezone detect
TZ=$(timedatectl 2>/dev/null | grep "Time zone" | awk '{print $3}')
TZ=${TZ:-Etc/UTC}

echo ""
echo "[+] Deploying $NAME browser..."

# Run container
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

# Get public IP
IP=$(curl -s ifconfig.me)

echo ""
echo "======================================="
echo "✅ Installation Complete!"
echo "======================================="
echo "🌐 Access your browser:"
echo "https://$IP:3001"
echo ""
echo "⚠️ Accept SSL warning (self-signed cert)"
echo "======================================="
