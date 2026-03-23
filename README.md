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

1. **SSH into the VPS** and copy `deploy/setup.sh` to the server, then run it:

   ```bash
   bash setup.sh
   ```

2. **Append the Caddy config** from `deploy/Caddyfile` to `/etc/caddy/Caddyfile`, then restart Caddy:

   ```bash
   systemctl restart caddy
   ```

3. **Add a DNS A record** for `shrmap.evangriffiths.org` pointing to the server IP.

4. **First deploy** from your local machine:

   ```bash
   git remote add deploy root@<your-ip>:/opt/shr-map.git
   git push deploy main
   ```

### Deploying changes

```bash
git push deploy main
```
