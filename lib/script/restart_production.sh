#!/bin/bash

# fixme: check for errors
# thank you again to stackoverflow for the answer to running as a subprocess
# http://stackoverflow.com/questions/3096561/fork-and-exec-in-bash
# i'm weak and running out of brain stamina
pull_branch_and_restart_apache(which_branch) {
  sleep 3
  /etc/init.d/apache2 stop

  git pull $which_branch
  bundle exec rake db:migrate

  /etc/init.d/apache2 start
}

pull_branch_and_restart_apache $1 &
