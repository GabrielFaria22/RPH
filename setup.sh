#!/bin/bash
# =============================================================================
# SETUP SCRIPT - Initialize Rails application with Docker
# =============================================================================
#
# This script:
#   1. Builds the Docker image
#   2. Generates a new Rails API application
#   3. Fixes file permissions
#   4. Rebuilds with the complete app
#
# Run once after cloning: ./setup.sh
# =============================================================================

set -e  # Exit on any error

echo ""
echo "========================================"
echo "  🚂 Rails API Foundation Setup"
echo "========================================"
echo ""

# ---------------------------------------------------------------------------
# Check Docker is running
# ---------------------------------------------------------------------------
if ! docker info > /dev/null 2>&1; then
  echo "❌ Docker is not running!"
  echo "   Please start Docker and try again."
  echo "   On WSL, you may need to run: sudo service docker start"
  exit 1
fi

# ---------------------------------------------------------------------------
# Step 1: Copy environment file
# ---------------------------------------------------------------------------
echo "📋 Step 1/5: Setting up environment file..."
if [ ! -f .env ]; then
  cp .env.example .env
  echo "   ✓ Created .env from .env.example"
else
  echo "   ✓ .env already exists"
fi
echo ""

# ---------------------------------------------------------------------------
# Step 2: Build Docker image
# ---------------------------------------------------------------------------
echo "📦 Step 2/5: Building Docker image..."
echo "   This downloads Ruby and installs gems."
echo "   First run takes 5-10 minutes..."
echo ""
docker compose build web
echo ""
echo "   ✓ Docker image built!"
echo ""

# ---------------------------------------------------------------------------
# Step 3: Generate Rails application
# ---------------------------------------------------------------------------
echo "🚂 Step 3/5: Generating Rails API application..."
echo "   Creating a new Rails 7.1 API-only application..."
echo ""

# Run 'rails new' inside the container
# Flags explained:
#   --api              Only API components (no views, browser features)
#   --database=postgresql  Use PostgreSQL adapter
#   --skip-git         Don't run git init (we already have git)
#   --skip-bundle      Don't run bundle install (already done in image)
#   --skip-test        Skip default test framework (we use RSpec)
#   --force            Overwrite existing files
docker compose run --rm web rails new . \
  --api \
  --database=postgresql \
  --skip-git \
  --skip-bundle \
  --skip-test \
  --force

echo ""
echo "   ✓ Rails application generated!"
echo ""

# ---------------------------------------------------------------------------
# Step 4: Fix file permissions
# ---------------------------------------------------------------------------
echo "🔧 Step 4/5: Fixing file permissions..."
# Docker sometimes creates files as root; this fixes that
sudo chown -R $USER:$USER .
chmod +x bin/*
echo "   ✓ Permissions fixed!"
echo ""

# ---------------------------------------------------------------------------
# Step 5: Rebuild with complete application
# ---------------------------------------------------------------------------
echo "📦 Step 5/5: Final rebuild with complete application..."
docker compose build
echo ""
echo "   ✓ Build complete!"
echo ""

# ---------------------------------------------------------------------------
# Done!
# ---------------------------------------------------------------------------
echo "========================================"
echo "  ✅ Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo ""
echo "  1. Start the application:"
echo "     docker compose up"
echo ""
echo "  2. Open in browser:"
echo "     http://localhost:3000"
echo ""
echo "  3. Commit your changes:"
echo "     git add ."
echo "     git commit -m \"Initial Rails API setup with Docker\""
echo "     git push origin main"
echo ""
echo "========================================"
echo ""
