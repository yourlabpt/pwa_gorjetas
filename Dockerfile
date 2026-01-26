# syntax=docker/dockerfile:1

FROM node:18-bullseye-slim AS frontend-builder
WORKDIR /app/frontend
ARG NEXT_PUBLIC_API_URL="http://localhost:3001"
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}
COPY frontend/package*.json ./
RUN npm ci
COPY frontend ./
RUN npm run build && npm prune --omit=dev

FROM node:18-bullseye-slim AS backend-builder
WORKDIR /app/backend
ARG DATABASE_URL="postgresql://user:pass@localhost:5432/db"
ENV DATABASE_URL=${DATABASE_URL}
COPY backend/package*.json ./
RUN npm ci
COPY backend ./
RUN npx prisma generate
RUN npm run build
RUN npm prune --omit=dev

FROM node:18-bullseye-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
# Ensure OpenSSL available for Prisma
RUN apt-get update && apt-get install -y --no-install-recommends openssl && rm -rf /var/lib/apt/lists/*
COPY --from=backend-builder /app/backend /app/backend
# Keep Prisma CLI available in the runtime image for migrations
RUN npm install --prefix /app/backend --no-save prisma@5.7.0
# Copy full built frontend (includes .next, node_modules, package files, public)
COPY --from=frontend-builder /app/frontend /app/frontend
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
EXPOSE 3000 3001
CMD ["/app/entrypoint.sh"]
