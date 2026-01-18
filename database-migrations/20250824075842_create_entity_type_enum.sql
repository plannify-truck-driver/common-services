-- Migration: Create entity type enum
DROP TYPE IF EXISTS "entity_type";
CREATE TYPE "entity_type" AS ENUM ('DRIVER', 'EMPLOYEE');