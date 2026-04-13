-- Migration: Create documents table
CREATE TABLE IF NOT EXISTS public."documents" (
    pk_document_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    s3_file_path TEXT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);
