# SHR Map

A map view of the Scottish Hill Running calendar

https://www.scottishhillrunners.uk/calendar.aspx

## Setup

Requires [Bun](https://bun.sh/).

```bash
# Install dependencies
bun install

# Run the dev server
bun run server.ts
```

Open <http://localhost:3000>

## Deployment

Deployed on a Hetzner VPS at <https://shrmap.evangriffiths.org>.

### Fresh server setup

1. **Add a DNS A record** for `shrmap.evangriffiths.org` pointing to the server IP.

2. **SSH into the VPS**, clone the repo, and run the setup script:

   ```bash
   ssh root@<your-ip>
   git clone https://github.com/evangriffiths/shr-map.git /opt/shr-map
   bash /opt/shr-map/deploy/setup.sh
   ```

   This installs Bun, installs dependencies, sets up the bare git repo with a deploy hook, starts the systemd service, and configures Caddy.

3. **Add `DEPLOY_SSH_KEY` secret** to the GitHub repo for auto-deploy:

   ```bash
   gh secret set DEPLOY_SSH_KEY < ~/.ssh/id_ed25519
   ```

### Deploying changes

Pushing to `main` on GitHub automatically deploys via GitHub Actions.
