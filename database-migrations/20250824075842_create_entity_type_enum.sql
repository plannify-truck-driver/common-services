-- Migration: Create entity type enum
DROP TYPE IF EXISTS "EntityType";
CREATE TYPE IF NOT EXISTS "EntityType" AS ENUM ('DRIVER', 'EMPLOYEE');