-- Migration: Create driver mail types table
CREATE TABLE IF NOT EXISTS public."driver_mail_types" (
    pk_driver_mail_type_id SERIAL PRIMARY KEY,
    label VARCHAR(100) NOT NULL,
    is_editable BOOLEAN DEFAULT TRUE NOT NULL
);
