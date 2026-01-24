-- Migration: Create driver mails table
CREATE TABLE IF NOT EXISTS public."driver_mails" (
    pk_driver_mail_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fk_driver_id UUID NOT NULL,
    fk_employee_id UUID,
    fk_mail_type_id INTEGER NOT NULL,
    email_used VARCHAR(255) NOT NULL,
    status mail_status NOT NULL,
    description VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE,

    FOREIGN KEY (fk_driver_id)
    REFERENCES drivers (pk_driver_id)
    ON DELETE CASCADE,
    FOREIGN KEY (fk_employee_id)
    REFERENCES employees (pk_employee_id)
    ON DELETE CASCADE,
    FOREIGN KEY (fk_mail_type_id)
    REFERENCES driver_mail_types (pk_driver_mail_type_id)
    ON DELETE CASCADE
);
