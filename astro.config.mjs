// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  site: 'https://ukrivers.co.uk',
  trailingSlash: 'always',
  integrations: [
    sitemap({
      // Content was reviewed and updated on this date (see src/lib/trust.ts).
      serialize(item) {
        item.lastmod = '2026-11-13T00:00:00.000Z';
        return item;
      },
    }),
  ],
  vite: {
    plugins: [tailwindcss()],
  },
});
