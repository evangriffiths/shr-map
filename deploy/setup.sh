#!/bin/bash
# One-time server setup for shr-map
# Run this on the VPS as root
set -e

echo "==> Installing Bun..."
if ! command -v bun &> /dev/null; then
  curl -fsSL https://bun.sh/install | bash
  ln -sf /root/.bun/bin/bun /usr/local/bin/bun
fi

echo "==> Setting up git bare repo..."
mkdir -p /opt/shr-map /opt/shr-map.git
cd /opt/shr-map.git && git init --bare
git symbolic-ref HEAD refs/heads/main

echo "==> Installing deploy hook..."
cp /dev/stdin /opt/shr-map.git/hooks/post-receive << 'HOOK'
#!/bin/bash
set -e

APP_DIR=/opt/shr-map
GIT_DIR=/opt/shr-map.git

echo "==> Deploying shr-map..."

git --work-tree=$APP_DIR --git-dir=$GIT_DIR checkout -f main

cd $APP_DIR
bun install

cp deploy/shr-map.service /etc/systemd/system/shr-map.service
systemctl daemon-reload

systemctl restart shr-map
echo "==> Deploy complete!"
HOOK
chmod +x /opt/shr-map.git/hooks/post-receive

echo "==> Enabling systemd service..."
# Service file will be copied from repo on first deploy

echo ""
echo "==> Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Add Caddyfile block: append deploy/Caddyfile to /etc/caddy/Caddyfile"
echo "  2. Run: systemctl restart caddy"
echo "  3. Add DNS A record for shrmap.evangriffiths.org -> this server's IP"
echo "  4. From your local machine: git push deploy main"
