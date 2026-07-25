/*
  # Newsletter subscribers table

  ## Overview
  Creates a dedicated table to store email addresses submitted via the
  River Guide Newsletter signup bar. This is a single-tenant, no-auth table:
  the public newsletter form (anon key) can insert new subscribers, and no
  sign-in screen exists in the app, so writes come from the anon role.

  ## New Table
  ### newsletter_subscribers
  - `id` (uuid, primary key) - Unique identifier
  - `email` (text, unique, not null) - Subscriber email address
  - `source` (text, default 'sticky_bar') - Where the signup originated
  - `created_at` (timestamptz, default now()) - When the signup occurred

  ## Security
  - Enable RLS on `newsletter_subscribers`.
  - Public (anon, authenticated) INSERT only — anyone can subscribe.
  - No SELECT/UPDATE/DELETE for anon: subscribers cannot be listed or
    modified from the public client. The unique email constraint prevents
    duplicate signups and makes re-subscribes a no-op error the form can
    treat as success.
*/

CREATE TABLE IF NOT EXISTS newsletter_subscribers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  source text NOT NULL DEFAULT 'sticky_bar',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;

-- Allow anyone (anon key from the public form) to insert a new subscriber.
DROP POLICY IF EXISTS "Anyone can subscribe to newsletter" ON newsletter_subscribers;
CREATE POLICY "Anyone can subscribe to newsletter"
  ON newsletter_subscribers FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);
