#!/bin/bash
# One-time server setup for shr-map
# Run this on the VPS as root
set -e

echo "==> Installing Bun..."
if ! command -v bun &> /dev/null; then
  apt-get install -y unzip
  curl -fsSL https://bun.sh/install | bash
  ln -sf /root/.bun/bin/bun /usr/local/bin/bun
fi

echo "==> Installing dependencies..."
cd /opt/shr-map
bun install

echo "==> Setting up bare repo for deploys..."
git clone --bare /opt/shr-map /opt/shr-map.git
cp deploy/post-receive /opt/shr-map.git/hooks/post-receive
chmod +x /opt/shr-map.git/hooks/post-receive

echo "==> Installing systemd service..."
cp deploy/shr-map.service /etc/systemd/system/shr-map.service
systemctl daemon-reload
systemctl enable shr-map
systemctl start shr-map

echo "==> Adding Caddy config..."
cat deploy/Caddyfile >> /etc/caddy/Caddyfile
systemctl restart caddy

echo ""
echo "==> Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Add DNS A record for shrmap.evangriffiths.org -> this server's IP"
echo "  2. Add DEPLOY_SSH_KEY secret to the GitHub repo for auto-deploy"
