-- Migration: Create entity type enum
CREATE TYPE IF NOT EXISTS "EntityType" AS ENUM ('DRIVER', 'EMPLOYEE');