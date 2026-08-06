-- Migration: Create driver_informations table
CREATE TABLE IF NOT EXISTS public."driver_informations" (
    pk_information_id SERIAL PRIMARY KEY,
    type "driver_informations_type" NOT NULL,
    message JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    show_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    start_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    end_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);
