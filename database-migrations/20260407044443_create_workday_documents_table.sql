-- Migration: Create workday documents table
CREATE TABLE IF NOT EXISTS public."workday_documents" (
    fk_driver_id UUID NOT NULL,
    month INTEGER NOT NULL,
    year INTEGER NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,

    PRIMARY KEY (fk_driver_id, month, year),
    FOREIGN KEY (fk_driver_id)
    REFERENCES drivers (pk_driver_id)
    ON DELETE CASCADE,
    CHECK (month >= 1 AND month <= 12)
);
