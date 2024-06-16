#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Setup database
bundle exec rails db:setup

# Run database migrations
bundle exec rails db:migrate

# Start the server
bundle exec rails server -b 0.0.0.0 -p $PORT

