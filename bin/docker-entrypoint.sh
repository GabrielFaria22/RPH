#!/bin/bash
set -e

echo "========================================"
echo "  Docker Entrypoint Starting"
echo "========================================"

if [ -f tmp/pids/server.pid ]; then
  echo "→ Removing stale server.pid..."
  rm tmp/pids/server.pid
fi

echo "→ Waiting for PostgreSQL to be ready..."
until pg_isready -h db -U rails_user -d crud_api_development -q; do
  echo "  PostgreSQL not ready, waiting 2 seconds..."
  sleep 2
done
echo "  ✓ PostgreSQL is ready!"

echo "→ Waiting for Redis to be ready..."
until redis-cli -h redis ping > /dev/null 2>&1; do
  echo "  Redis not ready, waiting 2 seconds..."
  sleep 2
done
echo "  ✓ Redis is ready!"

echo "→ Setting up database..."
bundle exec rails db:prepare
echo "  ✓ Database ready!"

echo "========================================"
echo "  Entrypoint complete!"
echo "========================================"

exec "$@"
