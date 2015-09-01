#!/bin/bash

# this script will restart the webrick web server used in development

# this script should not be run in production

restart_webrick() {
  sleep 3
  kill -2 $(ps aux | grep rails | grep -v grep | awk '//{print $2}')
  git pull $1
  rails s
}

restart_webrick &
