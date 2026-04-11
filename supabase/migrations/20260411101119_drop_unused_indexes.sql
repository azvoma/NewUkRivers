/*
  # Drop Unused Indexes

  ## Summary
  Removes six unused indexes that are consuming resources without providing query benefits.

  ## Indexes Removed

  ### public.rivers
  - `idx_rivers_region` - unused index on region column
  - `idx_rivers_featured` - unused index on featured column
  - `idx_rivers_slug` - unused index on slug column

  ### public.blog_posts
  - `idx_blog_posts_category` - unused index on category column
  - `idx_blog_posts_published` - unused index on published column
  - `idx_blog_posts_slug` - unused index on slug column

  ## Notes
  - Unused indexes waste storage and slow down write operations (INSERT/UPDATE/DELETE)
    without providing any read performance benefit
  - These can be recreated if query patterns change in future
*/

DROP INDEX IF EXISTS public.idx_rivers_region;
DROP INDEX IF EXISTS public.idx_rivers_featured;
DROP INDEX IF EXISTS public.idx_rivers_slug;
DROP INDEX IF EXISTS public.idx_blog_posts_category;
DROP INDEX IF EXISTS public.idx_blog_posts_published;
DROP INDEX IF EXISTS public.idx_blog_posts_slug;
