### Teudu
This is the teudu webservice. It's based off of RoR 3.1.

#### Getting Started for Development
Until we upgrade to the latest versions of Ruby and Ruby on Rails, we will use Docker (todo: link to docker)
to facilitate getting a development version of Teudu's codebase up and running on any Windows, Linux, or Mac
computer. When you have finished the steps below, you should have:
1. A copy of Teudu's source code
2. A browser window open to Teudu's homepage at address localhost:3000.

##### Mac
1. Download Docker.
2. Press Cmd + Space, then start typing in `docker quickstart terminal`. Press Enter when it shows up.
3. Run docker pull cswen17/teudu:devel
4. Run docker run -p 3000:3000 -i -t cswen17/teudu:devel
5. Open up your favorite internet browser, such as Google Chrome, Safari, Mozilla Firefox, etc.
6. Go to localhost:3000

##### Windows
1. Download Docker.
2. Look for `docker quickstart terminal` in your start menu.
3. Run docker pull cswen17/teudu:devel
4. Run docker run -p 3000:3000 -i -t cswen17/teudu:devel
5. Open up your favorite internet browser.
6. Go to localhost:3000

##### Linux
1. Download Docker.
2. Run docker pull cswen17/teudu:devel
3. Run docker run -p 3000:3000 -i -t cswen17/teudu:devel
4. Open up your favorite internet browser.
5. Go to localhost:3000

#### Backend Design
Teudu's main product or object is the Event.

#### Frontend Design


#### Deploying
https://teudu.andrew.cmu.edu/developer

#### Adding new users, org leaders, admins, or developers
You must have is_admin set to true on your Teudu account to do this:
https://teudu.andrew.cmu.edu/users
