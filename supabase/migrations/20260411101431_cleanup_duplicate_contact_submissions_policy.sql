/*
  # Clean up duplicate contact_submissions RLS policy

  ## Summary
  Removes the older duplicate INSERT policy on contact_submissions that was created
  by a prior migration, leaving only the correct restrictive policy in place.

  ## Changes
  - Drops `Anon users can submit valid contact forms` (older duplicate)
  - Retains `Anyone can submit contact forms` which already has proper WITH CHECK constraints
*/

DROP POLICY IF EXISTS "Anon users can submit valid contact forms" ON public.contact_submissions;
