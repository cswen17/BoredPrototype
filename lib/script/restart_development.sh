#!/bin/bash

# this script will restart the webrick web server used in development

# this script should not be run in production

call_restart_webrick() {
  echo "My PID is $$"
  echo "My PPID is $PPID"
  sleep 3
  ./lib/script/inner.sh $1
  # kill -2 $(ps aux | grep rails | grep -v grep | awk '//{print $2}')
  # git pull origin $1
  # rails s
}

call_restart_webrick $1 &
