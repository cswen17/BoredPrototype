## Teudu
This is the teudu webservice. In this README, you'll find information
on how to get started developing for Teudu, and how to submit your
changes to Teudu's code base.

### Getting Started
Until we upgrade to the latest versions of Ruby and Ruby on Rails,
we will use [Docker](https://www.docker.com/whatisdocker) to download
and install Ruby on Rails and clone a copy of Teudu's git repo. It's
free, so don't follow any links that ask you for payment.

You'll need at least 613 MB of free space on your computer to download
our recommended Docker image of Teudu, plus about 50 MB of free space
to download Docker.

We recommend keeping at least 1 GB of space free on your computer for
Teudu's development.

Having said that, it's totally okay to develop on Teudu without Docker.
There are instructions to get started without Docker on the Teudu wiki.

When you have finished the steps below, you should have:

1. An updated copy of Teudu's source code in the `BoredPrototype` directory
2. A browser window open to Teudu's homepage at some host on port :3000.

Select your Operating System to get started:
[Mac](#mac)

[Windows](#windows)

[Ubuntu](#ubuntu-or-linux)

#####Mac
1. Download [Docker](https://docs.docker.com/installation/mac).
   The installation instructions start under the section 'Installation',
   and the first step should say something like 'Go to the Docker
   Toolbox page.' Follow the instructions up to the section titled
   'From your shell'.
2. If you're already in the quickstart terminal then go on to the next
   step. Otherwise, press &#8984; + Space, then start typing in
   `docker quickstart terminal`. Press Enter.
3. `docker pull cswen17/teudu:devel`
4. `docker run -p 3000:3000 -d -i -t cswen17/teudu:devel /bin/bash -c 'git config --global user.name "<your name>" && git config --global user.email "<the email address linked to your github account>" && cd /root/BoredPrototype && git pull && bundle install && bundle exec rake db:migrate && rails s'`
5. Open up your favorite browser.
6. This step is a little tricky. We need to find the ip address of our
   docker virtual machine. Run `docker-machine ls`, then look for the
   'tcp:' or 'http:' address under the URL column.
7. Copy and paste that address into your browser, but replace the port
   number after the last ':' with 3000. An example address might look like
   '192.168.88.101:3000'. Now you should see the home page of Teudu.

#####Windows
1. Download [Docker](https://docs.docker.com/installation/windows).
   The installation instructions start under the section 'Installation',
   and the first step should say something like 'Go to the Docker
   Toolbox page.' Follow the instructions up to the section titled
   'From your shell', because docker quickstart terminal should be enough.
2. Look for `Docker Quickstart Terminal` on your desktop. Open it if
   you haven't already.
3. `docker pull cswen17/teudu:devel`
4. `docker run -p 3000:3000 -d -i -t cswen17/teudu:devel /bin/bash -c 'git config --global user.name "<your name>" && git config --global user.email "<the email address linked to your github account>" && cd /root/BoredPrototype && git pull && bundle install && bundle exec rake db:migrate && rails s'`
5. Open up your favorite browser.
6. This step is a little tricky. We need to find the ip address of our
   docker virtual machine. Run `docker-machine ls` in the Docker
   Quickstart Terminal, then look for the
   'tcp:' or 'http:' address under the URL column.
7. Copy and paste that address into your browser, but replace the port
   number after the last ':' with 3000. An example address might look like
   '192.168.88.101:3000'. Now you should see the home page of Teudu.

#####Ubuntu-or-Linux
1. Download [Docker](https://docs.docker.com/installation/ubuntulinux/).
   The first instruction where you're probably going to do anything is
   under the 'Installation' section and says something like 'Log into
   your Ubuntu installation as a user with `sudo` privileges'. Follow
   the instructions up to the section titled 'Enable UFW Forwarding'.
2. Open up a terminal window with Ctrl + Alt + T.
3. `docker pull cswen17/teudu:devel` (add sudo at the beginning if
   you didn't make a docker group yet)
4. `docker run -p 3000:3000 -d -i -t cswen17/teudu:devel /bin/bash -c 'git config --global user.name "<your name>" && git config --global user.email "<the email address linked to your github account>" && cd /root/BoredPrototype && git pull && bundle install && bundle exec rake db:migrate && rails s`
5. Open up your favorite internet browser.
6. Go to http://localhost:3000. Now you should see the home page of Teudu.

### Viewing and Editing Teudu's Source Code
Now that you have downloaded the Docker image for Teudu and launched
a Docker container for it, you can do the following things in your
new development environment:

We're working on some stuff mentioned in
[this blog post](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/)
to see if we can run Sublime and Notepad++ from within Docker, but until
then here are some commands to help you navigate Teudu's source code in
Docker and view it with vim or emacs.

Teudu's Docker image is built on another Docker image of the Ubuntu
operating system, so whatever you can do on Ubuntu you can do on Teudu.
But to get inside the Docker container, you'll need to figure out your
container's name or start a new one if it's not running:

1. Run `docker ps -a` in a quickstart terminal (Windows and Mac)
   or a terminal (Ubuntu). Do any of the listed containers
   contain 'teudu' in their image info? If so, look at the
   rightmost column of the output. It should be an easy-to-remember
   name, like terrific_tesla, or pondering_lotus or something like
   that. Remember that name. Note: if the container you found is not
   in the RUNNING state, then you may need to start it again
   with `docker start -d -i -t <container_name>`. If no container
   built on the image cswen17/teudu:devel can be found, you'll
   need to create a new one with
   `docker run -p 3000:3000 -d -i -t cswen17/teudu:devel /bin/bash cd /root/BoredPrototype && rails s`
   specifically with the `-p 3000:3000` flag to make the port mappings
   work. Then find the container name again with the steps above.
2. Run `docker attach <teudu_container_name>` with the name you remembered
   from step 1. Now you can use any command you would normally type
   into a terminal in Ubuntu (mostly the same commands as you use on your
   Andrew Unix machines).

### A Note on Secrets
Teudu needs a correctly filled-out file called 
BoredPrototype/config/secrets.yaml to display any images from dropbox,
or import events from facebook, or import events from Google Calendar.
Basically, it needs those secrets to get anything to show up. If you
get any errors about Dropbox when you're trying to look at Teudu's home
page in your development environment, then there might be something wrong
with secrets.yaml. You can make your own dropbox, facebook,
and google accounts and create an app called Teudu on them by following
their instructions for developing on their APIs and then filling out
secrets.yaml with your own keys, but we also have a copy
of secrets.yaml using Teudu's developer accounts on facebook, dropbox
and google, located on the Teudu wiki.

#### Users
In order to create an event on Teudu, the database must have at least
one user. The Teudu Docker image should have a default user named
Joe User baked into the database, but in case you're installing Teudu
outside of Docker, or maybe something broke and you're starting over
from scratch, here's a way to insert a user via rails console:

```
bundle exec rake db:migrate # just in case we don't have a Users table
rails console
> joe = User.new
> joe.first_name = 'Joe'
> joe.last_name = 'User'
> joe.andrew = 'admin'
> joe.is_admin = true
> joe.is_org_leader = true
> joe.is_developer = true
> joe.save
> quit
```

#### Organizations
In order to create an event on Teudu, the database must have at least
one organization. The Teudu Docker image should have an organization
baked into the database, but in case you're installing Teudu outside
of Docker (we completely understand, because Docker takes up a lot of
disk space), or maybe something broke and you're starting over from
scratch, here's a way to insert an organization via rails console.
However, an even easier way to create an organization is to use your
development version of the Teudu web app itself.

```
rails console
> org = Organization.new
> org.name = 'ACM'
> org.url = 'acmatcmu.org'
> org.save
> quit
```

#### Categories
In order to create an event on Teudu, it would help to have a couple
of categories to put the event into. The best way to make a new category
is through your development version of the Teudu web app, by clicking
on the 'Categories' item in the left nav drawer menu. All you need for
a category is a name.

Nonetheless, you can also create a category via rails console.

```
rails console
> arts = Category.new
> arts.name = 'Arts'
> arts.save
> academic = Category.new
> academic.name = 'Academic'
> academic.save
> quit
```

#### Create an Event
You should try to create an event from localhost:3000/events/new
in your development copy of Teudu's web app rather than through rails
console, but here's a quick walkthrough of the process for the required
event fields only:

```
rails console
> evt = Event.new
> evt.name = 'Teudu Meeting'
> evt.location = 'GHC 6th Floor Collaborative Commons'
> evt.description = 'Weekly developer meeting for Teudu'
> evt.event_start = Time.now
> evt.event_end = 3.hours.from(Time.now)
> org_id = Organization.first().id
> evt.organization_id = org_id
> user_id = User.first().id
> evt.user_id = user_id
> evt.save
> quit
```

### Submission Process
When you're making changes to Teudu, it's easier if you put your
changes on another git branch, because we have a self service deploy
tool that can deploy Teudu's code by searching for remote branches.
However, there are a couple of things you need to ensure about your
remote branches, although we have commands in case you did your work on
the master branch, or used a fork of the ACM@CMU repo for Teudu.
Let's start with your branch requirement:
Your branch should be a remote branch on
github.com/ACMCMU/BoredPrototype. To check, run
`git remote show origin`. Does the output look like the following?
```
* remote origin
   Fetch URL: https://github.com/ACMCMU/BoredPrototype
   Push  URL: https://github.com/ACMCMU/BoredPrototype
   HEAD branch: master
   Remote branches:
     your_initials/your_branch_name tracked
     master                         tracked
   Local refs configured for 'git push':
     your_initials/your_branch_name pushes to your_initials/your_branch_name (up to date)
     master              pushes to master              (up to date)
```
If not, try the following command, and if an error appears, try
the set of commands after that:
`git remote add origin`
If the name `origin` is already taken, we can always create another name.
`git remote add acm-cmu-origin https://github.com/ACMCMU/BoredPrototype`
Now we can use the name acm-cmu-origin to represent the ACMCMU fork
of Teudu's repo, which is where the production version of Teudu gets
its updates from.
 
So now, if you're not already working on a git branch that is not `master`:
```
git checkout -b your_initials/short_feature_summary
git add .
git commit -m "<your commit message>"
git push acm-cmu-origin your_initials/short_feature_summary
```
Otherwise:
```
git push acm-cmu-origin your_initials/short_feature_summary
```
Then read the next section on how to deploy your changes.


#### Deploying
Deploying is the process of publishing your code changes to Teudu's
production machine, whose address is at `teudu.andrew.cmu.edu`. After
you deploy your branch to Teudu, you'll be able to see the result of
your changes at www.teudu.org.

1. Go to https://www.teudu.org/developer
2. Click on the 'Deploy Teudu' tab.
3. Find your branch name in the list and click on it.

If anything weird happens, go to https://www.teudu.org/developer
and follow the instructions on the 'About' tab.

#### Adding new users, org leaders, admins, or developers
You must have is_admin set to true on your Teudu account to do this:
https://teudu.andrew.cmu.edu/users

#### Troubleshooting
It may be easier to edit the wiki than create a new commit on
the README for frequently asked questions:
(todo: link to wiki)
