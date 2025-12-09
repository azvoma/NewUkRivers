import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || '';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || '';

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('Missing Supabase environment variables');
  console.error('URL:', supabaseUrl ? 'present' : 'missing');
  console.error('Key:', supabaseAnonKey ? 'present' : 'missing');
}

export const supabase = createClient(
  supabaseUrl,
  supabaseAnonKey
);

export interface River {
  id: string;
  name: string;
  slug: string;
  region: string;
  length_km: number | null;
  length_miles: number | null;
  description: string | null;
  origin: string | null;
  mouth: string | null;
  wildlife: string[];
  activities: string[];
  has_gold: boolean;
  swimming_safety: string;
  fishing_season: string | null;
  latitude: number | null;
  longitude: number | null;
  featured: boolean;
  image_url: string | null;
  created_at: string;
  updated_at: string;
}

export interface BlogPost {
  id: string;
  title: string;
  slug: string;
  category: string;
  excerpt: string | null;
  content: string | null;
  image_url: string | null;
  published: boolean;
  published_at: string | null;
  created_at: string;
}
