source 'https://rubygems.org'

gem 'rails'

gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # I want standard JavaScript and CSS
  gem 'sass-rails'
  #gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # No JavaScript engine installed by default under Linux
  # See http://stackoverflow.com/questions/6282307/rails-3-1-execjs-and-could-not-find-a-javascript-runtime
  platforms :ruby do
    gem 'therubyracer'
  end

  gem 'uglifier'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-qtip2-rails'
gem 'fullcalendar-rails', git: 'https://github.com/tkrotoff/fullcalendar-rails.git'
gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'

gem 'simple_form'

gem 'rails-i18n'
gem 'i18n-js', '>= 3.0.0.rc2'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', require: false

  gem 'capybara'
  gem 'launchy'

  gem 'guard'
  gem 'guard-test'

  gem 'simplecov'
end
