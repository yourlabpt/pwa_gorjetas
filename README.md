# pwa_gorjetas
App that manages daily finances on restaurants and tips distribution

## Production deployment (Ubuntu, Docker + Caddy)

### Step-by-step (run on the server)
1) Prereqs: DNS A record for `DOMAIN` → server IP; ports 80/443 open:
```bash
sudo ufw allow 80,443/tcp
```
2) If you’re not in the docker group, either prefix commands with `sudo` or add yourself and re-login:
```bash
sudo usermod -aG docker $USER   # log out/in after this
```
3) From the repo root, prepare env (edit values after copying):
```bash
cp .env.production.example .env.production
nano .env.production   # set a real DOMAIN (DNS → server), ACME_EMAIL, POSTGRES_*, JWT_SECRET, CORS_ORIGINS=https://<DOMAIN>
```
4) Build and start the stack (frontend+backend behind Caddy TLS):
```bash
docker compose --env-file .env.production -f docker-compose.prod.yml up -d --build
```
5) Run database migrations (optional seed):
```bash
docker compose --env-file .env.production -f docker-compose.prod.yml exec app sh -c "cd /app/backend && npx prisma migrate deploy"
# optional: docker compose --env-file .env.production -f docker-compose.prod.yml exec app sh -c "cd /app/backend && npx prisma db seed"
```
6) Verify and follow logs (if `app` is not `Up`, check the app logs and fix env values):
```bash
sudo docker compose --env-file .env.production -f docker-compose.prod.yml ps
sudo docker compose --env-file .env.production -f docker-compose.prod.yml logs -f caddy
sudo docker compose --env-file .env.production -f docker-compose.prod.yml logs -f app
```
7) Access at `https://<DOMAIN>`; only Caddy on 80/443 is exposed and proxies `/api` to the backend on the private network.
8) Stop/update:
```bash
docker compose --env-file .env.production -f docker-compose.prod.yml down        # stop
docker compose --env-file .env.production -f docker-compose.prod.yml pull       # update images
docker compose --env-file .env.production -f docker-compose.prod.yml up -d --build  # rebuild & start
```

### Common TLS gotchas
- Use a real domain (not `app.example.com`) and point DNS A/AAAA to this server; port 80 must be reachable for HTTP validation.
- Set `ACME_EMAIL` in `.env.production` so Caddy can register with the CA.
- If issuance fails, check `docker compose ... logs -f caddy`, fix DNS/email, then re-run `docker compose --env-file .env.production -f docker-compose.prod.yml up -d` to retry.
- DuckDNS note: update your IP before retrying:
  `curl "https://www.duckdns.org/update?domains=<your-subdomain>&token=<your-token>&ip=$(curl -s https://api.ipify.org)"`, then verify with `dig +short <your-subdomain>.duckdns.org` matches your public IP.

### Simpler, no-public-ports option (Cloudflare Tunnel, free)
Use this if you are behind CGNAT/can’t open 80/443. Cloudflare handles TLS; we keep Caddy HTTP-only internally and skip ACME.
1) Install Docker as usual; `cp .env.production.example .env.production` (DOMAIN not used here, but fill DB/JWT).
2) Start the stack with the tunnel override (build uses relative API path):
```bash
docker compose --env-file .env.production -f docker-compose.prod.yml -f docker-compose.tunnel.yml up -d --build
```
3) Start a quick tunnel (prints a public `https://*.trycloudflare.com` URL):
```bash
docker compose -f docker-compose.prod.yml -f docker-compose.tunnel.yml run --rm cloudflared
```
Keep this running; the URL serves frontend and `/api` via the tunnel. To stop, Ctrl+C then `docker compose ... down`.
