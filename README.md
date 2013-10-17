Teudu
===

This is the teudu webservice. It's based off of RoR 3.1.

Deploying
---

To deploy, ssh into our server and restart Apache2, as follows:

ssh root@teudu.andrew.cmu.edu
# Ask Connie, Vilcya, Stephanie, or Avesh for password

#Go to web site directory (/var/www/teudu)
cd /var/www/teudu

#Pull from repo
git pull origin master

bundle install --path vendor/bundle  

# Clean all assets
bundle exec rake assets:clean
bundle exec rake assets:precompile

#Restart the server
sudo /etc/init.d apache2 restart


Database
---

We test online with the app deployed to Heroku. Since Heroku uses Postgres instead of sqlite, you should run bundle install with the development context.
`bundle install --without production`

Adding new moderators
---
Open up rails console
- rails console production

If user does not already exist in system:
Save new user record in database
- c = User.new
- c = first_name = <user's first name>
- c = last_name = <user's last name>
- c = andrew_id = <user's andrew id>
- c = moderator = true
- c.save!

If user does already exist in system
Modify user's record in database
- c = User.find_by_andrew_id("<andrew id>")
- c = moderator = true
- c.save!


Setup
---
Certificate stuff
http://www.cmu.edu/computing/web/authenticate/webiso/apache.html
http://www.cmu.edu/computing/doc/web/ca/request-certs.html

Debian RubyOnRails/passenger/apache installation
https://gist.github.com/1102852

Set write permissions for key directories (from Rails root directory)
- chmod -R 777 tmp/
- chmod -R 777 public/

Pubcookie setup
(Read from step 7 onwards and stop after the command ./keyclient. 
DO NOT execute ./keyclient -G keys/pubcookie_granting.cert)
http://parsedout.com/2007/12/installing-pubcookie-33-on-ubuntu-710-with-apache-2/

WebISO/pubcookie integration
https://github.com/alexcrichton/rack-pubcookie
https://github.com/alexcrichton/oa-pubcookie