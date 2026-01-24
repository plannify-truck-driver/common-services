-- Migration: Create mail status enum
DROP TYPE IF EXISTS "mail_status";
CREATE TYPE "mail_status" AS ENUM ('PENDING', 'SUCCESS', 'FAILED');