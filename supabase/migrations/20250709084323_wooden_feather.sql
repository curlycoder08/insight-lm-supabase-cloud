/*
  # Fix Vector Embedding Dimensions

  1. Changes
    - Update documents table embedding column to use 768 dimensions instead of 1536
    - This matches the actual embedding model being used in n8n

  2. Notes
    - This migration changes the vector dimension from 1536 to 768
    - All existing embeddings will need to be regenerated after this change
    - The embedding model in n8n appears to be using 768-dimensional vectors
*/

-- Drop the existing index first
DROP INDEX IF EXISTS documents_embedding_idx;

-- Drop the existing column
ALTER TABLE documents DROP COLUMN IF EXISTS embedding;

-- Add the column back with correct dimensions (768 instead of 1536)
ALTER TABLE documents ADD COLUMN embedding vector(768);

-- Recreate the index with the correct dimensions
CREATE INDEX documents_embedding_idx ON documents USING hnsw (embedding vector_cosine_ops);