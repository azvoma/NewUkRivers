/*
  # Fix newsletter_subscribers INSERT RLS policy

  ## Problem
  The existing INSERT policy "Anyone can subscribe to newsletter" used
  `WITH CHECK (true)`, which accepts ANY row shape from anon/authenticated
  callers. That effectively bypasses row-level security for inserts: a
  caller could insert rows with arbitrary column values (e.g. a malformed
  email, or a `source` value the app never uses). The security scanner
  flagged this as "RLS Policy Always True".

  ## Fix
  Replace the permissive policy with one that validates the inserted row:
  - `email` matches a basic email pattern (non-empty local part, @, domain).
  - `source` is one of the known signup origins the frontend actually sends
    ('sticky_bar'). The CHECK constraint below also enforces this at the
    column level so the rule cannot be bypassed even by a service-role write.
  - `email` is not null and not an empty string.

  The policy remains `TO anon, authenticated` because this is a single-tenant,
  no-auth app: the public newsletter form uses the anon key and there is no
  sign-in screen. SELECT/UPDATE/DELETE stay disallowed for anon/authenticated
  (subscribers cannot be listed or modified from the public client).

  ## Security changes
  - Drop and recreate the INSERT policy with a real WITH CHECK clause.
  - Add a CHECK constraint on `source` to whitelist allowed origins.
  - Add a CHECK constraint on `email` format at the column level.

  ## Notes
  1. No data is altered or deleted — only the policy and table constraints change.
  2. Existing rows with `source = 'sticky_bar'` remain valid under the new
     CHECK constraint.
*/

-- Whitelist the signup origins the frontend actually sends.
ALTER TABLE newsletter_subscribers
  DROP CONSTRAINT IF EXISTS newsletter_subscribers_source_check;
ALTER TABLE newsletter_subscribers
  ADD CONSTRAINT newsletter_subscribers_source_check
  CHECK (source IN ('sticky_bar'));

-- Enforce a sensible email shape at the column level too (defense in depth,
-- since the unique constraint only enforces uniqueness, not format).
ALTER TABLE newsletter_subscribers
  DROP CONSTRAINT IF EXISTS newsletter_subscribers_email_format_check;
ALTER TABLE newsletter_subscribers
  ADD CONSTRAINT newsletter_subscribers_email_format_check
  CHECK (email ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$');

-- Replace the permissive INSERT policy with one that validates the row.
DROP POLICY IF EXISTS "Anyone can subscribe to newsletter" ON newsletter_subscribers;
CREATE POLICY "Anyone can subscribe to newsletter"
  ON newsletter_subscribers FOR INSERT
  TO anon, authenticated
  WITH CHECK (
    email IS NOT NULL
    AND email ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$'
    AND source IN ('sticky_bar')
  );
