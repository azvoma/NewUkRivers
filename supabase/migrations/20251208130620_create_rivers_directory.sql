/*
  # UK Rivers Directory Database Schema

  ## Overview
  Creates comprehensive database structure for UK rivers directory including rivers data,
  activities, wildlife, blog posts, and contact submissions.

  ## New Tables
  
  ### 1. rivers
  - `id` (uuid, primary key) - Unique identifier
  - `name` (text) - River name
  - `slug` (text, unique) - URL-friendly name
  - `region` (text) - England, Scotland, Wales, or Northern Ireland
  - `length_km` (numeric) - River length in kilometers
  - `length_miles` (numeric) - River length in miles
  - `description` (text) - Detailed description
  - `origin` (text) - Where the river starts
  - `mouth` (text) - Where the river ends
  - `wildlife` (text[]) - Array of wildlife species
  - `activities` (text[]) - Available activities (kayaking, fishing, etc.)
  - `has_gold` (boolean) - Whether river contains gold deposits
  - `swimming_safety` (text) - Safety rating for wild swimming
  - `fishing_season` (text) - Fishing season information
  - `latitude` (numeric) - GPS coordinate
  - `longitude` (numeric) - GPS coordinate
  - `featured` (boolean) - Whether featured on homepage
  - `image_url` (text) - Main river image
  - `created_at` (timestamptz) - Record creation time
  - `updated_at` (timestamptz) - Last update time

  ### 2. blog_posts
  - `id` (uuid, primary key) - Unique identifier
  - `title` (text) - Blog post title
  - `slug` (text, unique) - URL-friendly title
  - `category` (text) - Wildlife, Activities, Safety, etc.
  - `excerpt` (text) - Short summary
  - `content` (text) - Full blog content
  - `image_url` (text) - Featured image
  - `published` (boolean) - Whether post is published
  - `published_at` (timestamptz) - Publication date
  - `created_at` (timestamptz) - Record creation time

  ### 3. contact_submissions
  - `id` (uuid, primary key) - Unique identifier
  - `name` (text) - Sender name
  - `email` (text) - Sender email
  - `subject` (text) - Message subject
  - `message` (text) - Message content
  - `submission_type` (text) - inquiry, correction, submission, etc.
  - `created_at` (timestamptz) - Submission time

  ## Security
  - Enable RLS on all tables
  - Public read access for rivers and published blog posts
  - Contact submissions are write-only for public
*/

-- Create rivers table
CREATE TABLE IF NOT EXISTS rivers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  region text NOT NULL,
  length_km numeric,
  length_miles numeric,
  description text,
  origin text,
  mouth text,
  wildlife text[] DEFAULT '{}',
  activities text[] DEFAULT '{}',
  has_gold boolean DEFAULT false,
  swimming_safety text DEFAULT 'Check local guidance',
  fishing_season text,
  latitude numeric,
  longitude numeric,
  featured boolean DEFAULT false,
  image_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create blog_posts table
CREATE TABLE IF NOT EXISTS blog_posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  slug text UNIQUE NOT NULL,
  category text NOT NULL,
  excerpt text,
  content text,
  image_url text,
  published boolean DEFAULT false,
  published_at timestamptz,
  created_at timestamptz DEFAULT now()
);

-- Create contact_submissions table
CREATE TABLE IF NOT EXISTS contact_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  subject text NOT NULL,
  message text NOT NULL,
  submission_type text DEFAULT 'inquiry',
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE rivers ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_submissions ENABLE ROW LEVEL SECURITY;

-- Rivers policies (public read)
CREATE POLICY "Rivers are publicly readable"
  ON rivers FOR SELECT
  TO anon
  USING (true);

-- Blog posts policies (public read for published posts)
CREATE POLICY "Published blog posts are publicly readable"
  ON blog_posts FOR SELECT
  TO anon
  USING (published = true);

-- Contact submissions policies (public insert only)
CREATE POLICY "Anyone can submit contact forms"
  ON contact_submissions FOR INSERT
  TO anon
  WITH CHECK (true);

-- Insert sample river data
INSERT INTO rivers (name, slug, region, length_km, length_miles, description, origin, mouth, wildlife, activities, has_gold, featured, swimming_safety) VALUES
('River Thames', 'river-thames', 'England', 346, 215, 'The River Thames is the longest river entirely in England and the second-longest in the United Kingdom. It flows through London and has been central to British history and culture for millennia.', 'Thames Head, Gloucestershire', 'North Sea via Thames Estuary', ARRAY['Swans', 'Herons', 'Pike', 'Perch', 'Eels'], ARRAY['Kayaking', 'Boating', 'Walking', 'Fishing', 'Wildlife watching'], false, true, 'Swimming not recommended in central London'),
('River Severn', 'river-severn', 'England', 354, 220, 'The River Severn is the longest river in the United Kingdom, flowing through Wales and England. Known for its tidal bore and the Severn Bridge crossings.', 'Plynlimon, Wales', 'Bristol Channel', ARRAY['Salmon', 'Otters', 'Kingfishers', 'Swans', 'Lamprey'], ARRAY['Kayaking', 'Fishing', 'Walking', 'Birdwatching'], true, true, 'Check local conditions'),
('River Trent', 'river-trent', 'England', 297, 185, 'The River Trent is one of the major rivers of England, flowing through the Midlands. It''s an important waterway for both commerce and recreation.', 'Staffordshire', 'Humber Estuary', ARRAY['Barbel', 'Chub', 'Pike', 'Herons'], ARRAY['Fishing', 'Boating', 'Walking', 'Cycling'], false, true, 'Safe in designated areas'),
('River Tay', 'river-tay', 'Scotland', 193, 120, 'The River Tay is Scotland''s longest river and has the largest discharge in Great Britain. Famous for salmon fishing and scenic Highland landscapes.', 'Ben Lui, Scottish Highlands', 'Firth of Tay, North Sea', ARRAY['Atlantic Salmon', 'Sea Trout', 'Otters', 'Ospreys', 'Seals'], ARRAY['Salmon fishing', 'Kayaking', 'Wildlife watching', 'Walking'], true, true, 'Very cold, experienced swimmers only'),
('River Wye', 'river-wye', 'Wales', 215, 134, 'The River Wye flows through Wales and England, renowned for its natural beauty and designated as an Area of Outstanding Natural Beauty for much of its length.', 'Plynlimon, Wales', 'River Severn near Chepstow', ARRAY['Salmon', 'Otters', 'Kingfishers', 'Dippers'], ARRAY['Canoeing', 'Fishing', 'Walking', 'Camping'], false, false, 'Popular for wild swimming'),
('River Clyde', 'river-clyde', 'Scotland', 176, 109, 'The River Clyde flows through Glasgow and was historically vital to Scotland''s shipbuilding industry. Now a focus of urban regeneration.', 'Lowther Hills', 'Firth of Clyde', ARRAY['Salmon', 'Sea Trout', 'Seals', 'Herons'], ARRAY['Walking', 'Cycling', 'Fishing'], false, false, 'Not recommended for swimming'),
('River Ouse (Yorkshire)', 'river-ouse-yorkshire', 'England', 208, 129, 'The Yorkshire Ouse is formed by the confluence of the River Ure and River Swale, flowing through York to join the River Trent.', 'Confluence of Ure and Swale', 'Humber Estuary', ARRAY['Pike', 'Roach', 'Bream', 'Swans'], ARRAY['Fishing', 'Boating', 'Walking'], false, false, 'Check conditions'),
('River Dee (Wales)', 'river-dee-wales', 'Wales', 113, 70, 'The River Dee rises in Snowdonia and flows through Wales and England, known for its salmon and beautiful valley scenery.', 'Snowdonia, Wales', 'Irish Sea at Chester', ARRAY['Salmon', 'Brown Trout', 'Otters', 'Dippers'], ARRAY['Fishing', 'Kayaking', 'Walking', 'Rafting'], false, false, 'Safe in many areas');

-- Insert sample blog posts
INSERT INTO blog_posts (title, slug, category, excerpt, content, published, published_at) VALUES
('Top 10 Wildlife Species in UK Rivers', 'top-10-wildlife-species-uk-rivers', 'Wildlife', 'Discover the amazing wildlife that calls UK rivers home, from otters to kingfishers.', 'UK rivers support an incredible diversity of wildlife. From the majestic otter to the vibrant kingfisher, our waterways are teeming with life...', true, now()),
('Best Rivers for Wild Swimming in the UK', 'best-rivers-wild-swimming-uk', 'Activities', 'A guide to the safest and most beautiful spots for wild swimming in UK rivers.', 'Wild swimming has become increasingly popular. Here are the best UK rivers for a safe and enjoyable swimming experience...', true, now()),
('Fishing Seasons Explained: UK Rivers Guide', 'fishing-seasons-explained-uk-rivers', 'Activities', 'Everything you need to know about fishing seasons and regulations for UK rivers.', 'Understanding fishing seasons is crucial for both conservation and legal compliance. This guide covers all you need to know...', true, now()),
('Chalk Rivers: Britain''s Rare Treasure', 'chalk-rivers-britain-rare-treasure', 'Wildlife', 'Learn about the UK''s rare chalk rivers and why they''re so important for biodiversity.', 'Chalk rivers are globally rare habitats, and the UK has 85% of the world''s chalk streams. These crystal-clear waters support unique ecosystems...', true, now());

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_rivers_region ON rivers(region);
CREATE INDEX IF NOT EXISTS idx_rivers_featured ON rivers(featured);
CREATE INDEX IF NOT EXISTS idx_rivers_slug ON rivers(slug);
CREATE INDEX IF NOT EXISTS idx_blog_posts_category ON blog_posts(category);
CREATE INDEX IF NOT EXISTS idx_blog_posts_published ON blog_posts(published);
CREATE INDEX IF NOT EXISTS idx_blog_posts_slug ON blog_posts(slug);