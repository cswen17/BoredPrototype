#!/bin/bash

# this script will restart the webrick web server used in development

# this script should not be run in production

call_restart_apache() {
  ./lib/script/production_inner_restart.sh $1
}

call_restart_apache $1 &
