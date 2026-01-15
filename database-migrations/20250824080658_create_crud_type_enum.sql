-- Migration: Create crud type enum
DROP TYPE IF EXISTS "CrudType";
CREATE TYPE "CrudType" AS ENUM ('R', 'C', 'U', 'D');