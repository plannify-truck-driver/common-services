-- Drop old column if they still exist
ALTER TABLE public."employees" DROP COLUMN IF EXISTS professional_email_password;