import { rivers, blogPosts } from './data';

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

export function getRivers() {
  return rivers;
}

export function getRiverBySlug(slug: string) {
  return rivers.find(river => river.slug === slug);
}

export function getRiversByRegion(region: string) {
  return rivers.filter(river => river.region === region);
}

export function getBlogPosts() {
  return blogPosts.filter(post => post.published);
}
