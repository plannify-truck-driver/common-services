-- Migration: Create driver suspensions table
CREATE TABLE IF NOT EXISTS public."driver_suspensions" (
    pk_driver_suspension_id SERIAL PRIMARY KEY,
    fk_driver_id UUID NOT NULL,
    fk_created_employee_id UUID NOT NULL,
    can_access_restricted_space BOOLEAN NOT NULL,
    driver_message TEXT,
    title TEXT NOT NULL,
    description TEXT,
    start_at TIMESTAMP WITH TIME ZONE NOT NULL,
    end_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,

    CONSTRAINT fk_driver_id
    FOREIGN KEY (fk_driver_id)
    REFERENCES drivers(pk_driver_id)
    ON DELETE CASCADE,
    CONSTRAINT fk_created_employee_id
    FOREIGN KEY (fk_created_employee_id)
    REFERENCES employees(pk_employee_id)
    ON DELETE CASCADE
);
