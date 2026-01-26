-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'GESTOR', 'SUPERVISOR');

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'GESTOR',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_restaurant" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "restID" INTEGER NOT NULL,
    "roleOverride" "UserRole",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_restaurant_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "user_restaurant_restID_idx" ON "user_restaurant"("restID");

-- CreateIndex
CREATE UNIQUE INDEX "user_restaurant_userId_restID_key" ON "user_restaurant"("userId", "restID");

-- AddForeignKey
ALTER TABLE "user_restaurant" ADD CONSTRAINT "user_restaurant_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_restaurant" ADD CONSTRAINT "user_restaurant_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE CASCADE ON UPDATE CASCADE;
