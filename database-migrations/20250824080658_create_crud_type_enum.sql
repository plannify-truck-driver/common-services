-- Migration: Create crud type enum
CREATE TYPE IF NOT EXISTS "CrudType" AS ENUM ('R', 'C', 'U', 'D');