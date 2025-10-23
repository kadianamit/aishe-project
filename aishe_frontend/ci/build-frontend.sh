#!/bin/bash
set -e

cd "$(dirname "$0")/.."

# Clean up previous build artifacts
rm -rf node_modules

# Set up a local npm cache
mkdir -p /tmp/.npm
export npm_config_cache=/tmp/.npm

# Install dependencies and build the application
npm ci --legacy-peer-deps
npm run build