#!/bin/bash

restart_webrick() {
  sleep 3
  kill -2 $(ps aux | grep rails | grep -v grep | awk '//{print $2}')
  git pull origin $1
  rails s
}

restart_webrick $1 &
