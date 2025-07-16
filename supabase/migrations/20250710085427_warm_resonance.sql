/*
  # Fix RLS policies for sources table

  1. Security Updates
    - Drop existing RLS policies for sources table
    - Create new RLS policies with correct auth.uid() function
    - Ensure policies properly check notebook ownership

  2. Changes
    - Replace uid() with auth.uid() in all policies
    - Maintain existing security logic for notebook ownership validation
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Users can create sources in their notebooks" ON sources;
DROP POLICY IF EXISTS "Users can view sources from their notebooks" ON sources;
DROP POLICY IF EXISTS "Users can update sources in their notebooks" ON sources;
DROP POLICY IF EXISTS "Users can delete sources from their notebooks" ON sources;

-- Create new policies with correct auth function
CREATE POLICY "Users can create sources in their notebooks"
  ON sources
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM notebooks 
      WHERE notebooks.id = sources.notebook_id 
      AND notebooks.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can view sources from their notebooks"
  ON sources
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM notebooks 
      WHERE notebooks.id = sources.notebook_id 
      AND notebooks.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update sources in their notebooks"
  ON sources
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM notebooks 
      WHERE notebooks.id = sources.notebook_id 
      AND notebooks.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete sources from their notebooks"
  ON sources
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM notebooks 
      WHERE notebooks.id = sources.notebook_id 
      AND notebooks.user_id = auth.uid()
    )
  );