source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

platforms :ruby do
  gem 'sqlite3'
end

platforms :jruby do
  gem 'activerecord-jdbc-adapter'
  gem 'jdbc-sqlite3'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # I want standard JavaScript and CSS
  #gem 'sass-rails',   '~> 3.1.4'
  #gem 'coffee-rails', '~> 3.1.1'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false

  gem 'capybara'
  gem 'launchy'

  gem 'guard'
  gem 'guard-test'

  gem 'simplecov'
end
