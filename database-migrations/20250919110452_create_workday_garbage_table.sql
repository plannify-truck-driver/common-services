-- Migration: Create driver workday garbage table
CREATE TABLE IF NOT EXISTS public."workday_garbage" (
    workday_date DATE NOT NULL,
    fk_driver_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    scheduled_deletion_date DATE NOT NULL,

    PRIMARY KEY (workday_date, fk_driver_id),
    CONSTRAINT fk_workday_date
    FOREIGN KEY (workday_date, fk_driver_id)
    REFERENCES workdays (date, fk_driver_id)
    ON DELETE CASCADE
);-- Add migration script here
