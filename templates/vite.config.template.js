import fs from 'fs';
import { defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite';
import laravel from 'laravel-vite-plugin';
import { wordpressPlugin, wordpressThemeJson } from '@roots/vite-plugin';

export default defineConfig({
  base: '/app/wp-content/themes/{{PROJECT_NAME}}/',
  plugins: [
    tailwindcss(),
    laravel({
      input: [
        'resources/css/app.css',
        'resources/js/app.js',
        'resources/css/editor.css',
        'resources/js/editor.js',
      ],
      refresh: true,
      watch: {
        usePolling: true,
        interval: 1000,
        ignored: ['node_modules', 'public/build/hot'],
      },
    }),

    wordpressPlugin(),

    // Generate the theme.json file in the public/build/assets directory
    // based on the Tailwind config and the theme.json file from base theme folder
    wordpressThemeJson({
      disableTailwindColors: false,
      disableTailwindFonts: false,
      disableTailwindFontSizes: false,
    }),
  ],
  resolve: {
    alias: {
      '@scripts': '/resources/js',
      '@styles': '/resources/css',
      '@fonts': '/resources/fonts',
      '@images': '/resources/images',
    },
  },
  server: {
    https: {
      key: fs.readFileSync('/certs/cert.key'),
      cert: fs.readFileSync('/certs/cert.crt'),
    },
    host: true,
    port: 3009,
    hmr: { host: 'localhost', protocol: 'wss' },
  },
});
