#!/bin/bash

# Phase 1 MVP Setup Script
# Starts all services and runs migrations + seed

set -e

echo "🚀 Starting PWA Restaurantes Lisboa - Phase 1 MVP Setup"
echo ""

# Check Docker
echo "1️⃣  Checking Docker..."
if ! command -v docker &> /dev/null; then
  echo "❌ Docker is not installed"
  exit 1
fi

if ! docker info &> /dev/null; then
  echo "❌ Docker daemon is not running. Please start Docker."
  exit 1
fi

echo "✅ Docker is ready"
echo ""

# Clean up old volumes
echo "2️⃣  Cleaning up old database..."
docker-compose down -v 2>/dev/null || true

# Start PostgreSQL
echo "3️⃣  Starting PostgreSQL..."
docker-compose up -d
sleep 10

if [ "$(docker ps -q -f name=pwa_restaurantes_db)" ]; then
  echo "✅ PostgreSQL is running"
else
  echo "❌ PostgreSQL failed to start"
  exit 1
fi

echo ""
echo "4️⃣  Setting up Backend..."
cd backend

# Install dependencies
if [ ! -d "node_modules" ]; then
  echo "📦 Installing dependencies..."
  npm install
fi

echo "✅ Dependencies installed"

# Setup database
echo ""
echo "5️⃣  Setting up Database..."
echo "   - Running migrations..."
npx prisma migrate dev --name init --skip-generate

echo "   - Seeding data..."
npx prisma db seed

echo "✅ Database setup complete"

cd ..

echo ""
echo "6️⃣  Setting up Frontend..."
cd frontend

if [ ! -d "node_modules" ]; then
  echo "📦 Installing dependencies..."
  npm install
fi

echo "✅ Frontend ready"

cd ..

echo ""
echo "========================================="
echo "🎉 Setup Complete!"
echo "========================================="
echo ""
echo "📋 Next steps:"
echo ""
echo "Terminal 1 - Backend:"
echo "  cd backend && npm run start:dev"
echo "  (Server will run on http://localhost:3001)"
echo ""
echo "Terminal 2 - Frontend:"
echo "  cd frontend && npm run dev"
echo "  (App will run on http://localhost:3000)"
echo ""
echo "📱 Open http://localhost:3000 in your browser"
echo ""
echo "✨ Seeded data:"
echo "   - Restaurant: 'Restaurante Test' (base tip: 11%)"
echo "   - Employees: João, Maria, Chef Nunes, Douglas Silva"
echo "   - Tip configs: garcom 7%, cozinha 3%, douglas 1%"
echo ""
echo "🛑 To stop:"
echo "  docker-compose down"
echo ""
