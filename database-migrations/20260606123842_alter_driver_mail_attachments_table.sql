-- Add fk_document_id as NOT NULL
ALTER TABLE public."driver_mail_attachments" ADD COLUMN IF NOT EXISTS fk_document_id UUID NOT NULL;

-- Add FK constraint only if it does not already exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'fk_document'
          AND conrelid = 'public.driver_mail_attachments'::regclass
    ) THEN
        ALTER TABLE public."driver_mail_attachments"
            ADD CONSTRAINT fk_document
            FOREIGN KEY (fk_document_id)
            REFERENCES public."documents" (pk_document_id)
            ON DELETE CASCADE;
    END IF;
END $$;

-- Drop old columns if they still exist
ALTER TABLE public."driver_mail_attachments" DROP COLUMN IF EXISTS file_name;
ALTER TABLE public."driver_mail_attachments" DROP COLUMN IF EXISTS file_path;
ALTER TABLE public."driver_mail_attachments" DROP COLUMN IF EXISTS created_at;
