ALTER TABLE public."workday_documents" ADD fk_document_id UUID NOT NULL;
ALTER TABLE public."workday_documents" ADD CONSTRAINT fk_document
 FOREIGN KEY (fk_document_id)
 REFERENCES public."documents" (pk_document_id)
 ON DELETE CASCADE;
ALTER TABLE public."workday_documents" DROP COLUMN file_name, DROP COLUMN file_path, DROP COLUMN created_at;