# pwa_gorjetas
App that manages daily finances on restaurants and tips distribution

## Production deployment (Ubuntu, Docker + Caddy)

### Step-by-step (run on the server)
1) Prereqs: DNS A record for `DOMAIN` → server IP; ports 80/443 open:
```bash
sudo ufw allow 80,443/tcp
```
2) From the repo root, prepare env (edit values after copying):
```bash
cp .env.production.example .env.production
nano .env.production   # set DOMAIN, POSTGRES_*, JWT_SECRET, CORS_ORIGINS=https://<DOMAIN>
```
3) Build and start the stack (frontend+backend behind Caddy TLS):
```bash
docker compose --env-file .env.production -f docker-compose.prod.yml up -d --build
```
4) Run database migrations (optional seed):
```bash
docker compose --env-file .env.production -f docker-compose.prod.yml exec app npx prisma migrate deploy
# optional: docker compose --env-file .env.production -f docker-compose.prod.yml exec app npx prisma db seed
```
5) Verify and follow logs:
```bash
docker compose --env-file .env.production -f docker-compose.prod.yml ps
docker compose --env-file .env.production -f docker-compose.prod.yml logs -f caddy
docker compose --env-file .env.production -f docker-compose.prod.yml logs -f app
```
6) Access at `https://<DOMAIN>`; only Caddy on 80/443 is exposed and proxies `/api` to the backend on the private network.
7) Stop/update:
```bash
docker compose --env-file .env.production -f docker-compose.prod.yml down        # stop
docker compose --env-file .env.production -f docker-compose.prod.yml pull       # update images
docker compose --env-file .env.production -f docker-compose.prod.yml up -d --build  # rebuild & start
```
