source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer'
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'uglifier'
end

gem 'coffee-script'
gem 'jquery-rails'
gem 'paperclip', '~>2.4'
<<<<<<< HEAD
=======
gem 'omniauth', '~>1.1.0'
gem 'kaminari'
>>>>>>> 2a9467c0e197a85ca44dd621fe9b8a06ea959899
#gem "oa-pubcookie", :git => 'git://github.com/alexcrichton/oa-pubcookie.git'
gem "oa-pubcookie", "~> 0.1.0"

gem "google-api-client" #For importing GCal data

# Deploy with to Heroku for testing
# Use postgres for database as Heroku doesn't support sqlite3
group :production do
  gem 'sqlite3'
  gem 'faker'   # Temporary for seeding purposes(?)
end

group :development do
  gem 'sqlite3'
  # gem 'faker'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
gem 'debugger'

group :test do
  # Pretty printed test output
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails', "~> 3.0"
end
