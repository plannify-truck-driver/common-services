-- Migration: Create updates table
CREATE TABLE IF NOT EXISTS public."updates" (
    pk_update_id SERIAL PRIMARY KEY,
    version VARCHAR(20) NOT NULL,
    description TEXT NOT NULL,
    entity_type "EntityType" NOT NULL,
    mandatory_completion_date TIMESTAMP WITH TIME ZONE,
    fk_created_employee_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,

    CONSTRAINT fk_created_employee_id
    FOREIGN KEY (fk_created_employee_id)
    REFERENCES employees(pk_employee_id)
    ON DELETE CASCADE
);
