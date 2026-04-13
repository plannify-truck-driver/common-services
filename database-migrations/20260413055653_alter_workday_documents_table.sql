-- Add fk_document_id as nullable first (idempotent)
ALTER TABLE public."workday_documents" ADD COLUMN IF NOT EXISTS fk_document_id UUID;

-- Add FK constraint only if it does not already exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'fk_document'
          AND conrelid = 'public.workday_documents'::regclass
    ) THEN
        ALTER TABLE public."workday_documents"
            ADD CONSTRAINT fk_document
            FOREIGN KEY (fk_document_id)
            REFERENCES public."documents" (pk_document_id)
            ON DELETE CASCADE;
    END IF;
END $$;

-- Drop old columns if they still exist
ALTER TABLE public."workday_documents" DROP COLUMN IF EXISTS file_name;
ALTER TABLE public."workday_documents" DROP COLUMN IF EXISTS file_path;
ALTER TABLE public."workday_documents" DROP COLUMN IF EXISTS created_at;
