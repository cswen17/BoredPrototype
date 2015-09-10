#!/bin/bash

pull_branch_and_restart_apache() {
  sleep 3
  /etc/init.d/apache2 stop

  git pull $1
  bundle exec rake db:migrate
  bundle exec rake assets:precompile

  /etc/init.d/apache2 start
}

# thank you again to stackoverflow for the answer to running as a subprocess
# http://stackoverflow.com/questions/3096561/fork-and-exec-in-bash
# i'm weak and running out of brain stamina
pull_branch_and_restart_apache $1 &
