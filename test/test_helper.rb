# Code coverage
require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Configure Capybara for the integration tests
# See Capybara documentation https://github.com/jnicklas/capybara
require 'capybara/rails'
Capybara.current_driver = :selenium

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  # Selenium (or any of the external drivers, which aren't Rack::Test)
  # do not have access to information that has been written to the database
  # since the transaction hasn't been "committed".
  # See Rails integration test with selenium as webdriver http://stackoverflow.com/questions/6154687/rails-integration-test-with-selenium-as-webdriver-cant-sign-in
  # See Using Capybara with plain Rails’ integration tests http://blag.ahax.de/post/1581758817/using-capybara-with-plain-rails-integration-tests-and
  # See Request Specs and Capybara http://railscasts.com/episodes/257-request-specs-and-capybara
  self.use_transactional_fixtures = false
end
