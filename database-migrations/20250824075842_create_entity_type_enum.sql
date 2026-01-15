-- Migration: Create entity type enum
DROP TYPE IF EXISTS "EntityType";
CREATE TYPE "EntityType" AS ENUM ('DRIVER', 'EMPLOYEE');