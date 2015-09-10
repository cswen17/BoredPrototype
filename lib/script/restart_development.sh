#!/bin/bash

# this script will restart the webrick web server used in development

# this script should not be run in production

call_restart_webrick() {
  ./lib/script/development_inner_restart.sh $1
}

call_restart_webrick $1 &
