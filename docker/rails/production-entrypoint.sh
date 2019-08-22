#!/bin/bash
rm -f /var/leave/tmp/pids/server.pid \
&& ls /var/leave/public/packs \
&& RAILS_ENV=production /var/leave/bin/rails webpacker:compile \
&& /var/leave/bin/rails s -e production -p 3000