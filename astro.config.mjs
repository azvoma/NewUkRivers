// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
  site: 'https://ukrivers.co.uk',
  trailingSlash: 'never',
  integrations: [sitemap()],
});
