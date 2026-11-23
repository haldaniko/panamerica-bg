import { defineConfig } from 'vite'

const backendTarget = process.env.VITE_BACKEND_URL || 'http://localhost:8000'

export default defineConfig({
  server: {
    host: '0.0.0.0',
    proxy: {
      '/api': backendTarget,
      '/health': backendTarget,
      '/django-admin': backendTarget,
      '/media': backendTarget,
      '/static': backendTarget,
    },
  },
})
