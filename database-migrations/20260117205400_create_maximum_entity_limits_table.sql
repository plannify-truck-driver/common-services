-- Migration: Create maximum entity limits table
CREATE TABLE IF NOT EXISTS public."maximum_entity_limits" (
    pk_maximum_entity_limit_id SERIAL PRIMARY KEY,
    entity_type "entity_type" NOT NULL,
    maximum_limit INTEGER NOT NULL,
    fk_created_employee_id UUID NOT NULL,
    start_at TIMESTAMP WITH TIME ZONE NOT NULL,
    end_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,

    CONSTRAINT fk_created_employee_id
    FOREIGN KEY (fk_created_employee_id)
    REFERENCES employees(pk_employee_id)
    ON DELETE CASCADE
);
