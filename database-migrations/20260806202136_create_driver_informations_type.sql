-- Migration: Create driver_informations type
DROP TYPE IF EXISTS "driver_informations_type";
CREATE TYPE "driver_informations_type" AS ENUM ('INFO', 'WARNING');