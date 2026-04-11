/*
  # Fix contact_submissions RLS INSERT Policy

  ## Summary
  Replaces the unrestricted `WITH CHECK (true)` INSERT policy with one that enforces
  basic data integrity constraints, preventing spam or empty submissions.

  ## Changes

  ### public.contact_submissions
  - Drops the existing `Anyone can submit contact forms` policy (WITH CHECK always true)
  - Adds a new policy that requires name, email, subject, and message to be non-empty strings

  ## Security Notes
  - The table is a public contact form, so anon role must be allowed to INSERT
  - The new WITH CHECK clause ensures submissions contain meaningful data
  - This prevents empty/blank submissions from bypassing the form validation
*/

DROP POLICY IF EXISTS "Anyone can submit contact forms" ON public.contact_submissions;

CREATE POLICY "Anyone can submit contact forms"
  ON public.contact_submissions
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (
    length(trim(name)) > 0
    AND length(trim(email)) > 0
    AND email LIKE '%@%'
    AND length(trim(subject)) > 0
    AND length(trim(message)) > 0
  );
