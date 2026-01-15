-- Migration: Create crud type enum
DROP TYPE IF EXISTS "CrudType";
CREATE TYPE IF NOT EXISTS "CrudType" AS ENUM ('R', 'C', 'U', 'D');