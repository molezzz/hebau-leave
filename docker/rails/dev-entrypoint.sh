#!/bin/bash

set -e

if [[ "$1" = '--server' || "$2" = '--server' ]]; then 
    echo "Hebau Leave production ..."
    cd /var/leave \
    && rm -f /var/leave/tmp/pids/server.pid \
    && RAILS_ENV=production bundle exec rails webpacker:compile \
    && RAILS_ENV=production bundle exec rails assets:precompile \
    && bundle exec rails s -e production
    exit 0
fi

exec "$@"