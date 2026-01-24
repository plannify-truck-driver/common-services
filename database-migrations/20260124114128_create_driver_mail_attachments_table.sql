-- Migration: Create driver mail attachments table
CREATE TABLE IF NOT EXISTS public."driver_mail_attachments" (
    pk_driver_mail_attachment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fk_driver_mail_id UUID NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,

    FOREIGN KEY (fk_driver_mail_id)
    REFERENCES driver_mails (pk_driver_mail_id)
    ON DELETE CASCADE
);
