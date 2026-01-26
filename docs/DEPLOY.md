# Deploy & Run (Quick Guide)

## Prereqs
- Docker (Desktop on Windows/macOS)
- PostgreSQL connection string (`DATABASE_URL`)
- Secrets: `JWT_SECRET`
- Frontend API URL: `NEXT_PUBLIC_API_URL` (e.g., `http://localhost:3001` or your host URL)

## Build the single image
```bash
docker build -t restaurantes-all-in-one .
```

## Run locally
- **Windows/macOS (Docker Desktop):**
  ```bash
  docker run --rm -p 3000:3000 -p 3001:3001 \
    -e DATABASE_URL="postgres://user:pass@host:5432/db" \
    -e JWT_SECRET="change-me" \
    -e NEXT_PUBLIC_API_URL="http://localhost:3001" \
    restaurantes-all-in-one
  ```
  Frontend: http://localhost:3000 — Backend API: http://localhost:3001

## Run locally with Postgres via docker-compose
```bash
docker compose up --build
```
- Frontend: http://localhost:3000
- Backend: http://localhost:3001
- Postgres: `postgres://app:app@localhost:5432/app` (data persisted in `postgres_data` volume)

## Deploy to the cloud (any host that runs Docker)
1) Push image to a registry:
   ```bash
   docker tag restaurantes-all-in-one your-registry/restaurant-app:latest
   docker push your-registry/restaurant-app:latest
   ```
2) Create a container service (Render, Railway, Fly, AWS ECS/Fargate, DO App Platform, etc.).
3) Set env vars: `DATABASE_URL`, `JWT_SECRET`, `PORT=3001`, `FRONTEND_PORT=3000`, `NEXT_PUBLIC_API_URL="https://your-api-host:3001"` (or same host if both ports exposed).
4) Expose ports 3000 (web) and 3001 (API) or place behind a reverse proxy.

That’s it—single container runs both frontend and backend; managed Postgres stays in the cloud.
