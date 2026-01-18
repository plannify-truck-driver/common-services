-- Migration: Create crud type enum
DROP TYPE IF EXISTS "crud_type";
CREATE TYPE "crud_type" AS ENUM ('R', 'C', 'U', 'D');