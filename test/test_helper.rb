# Code coverage
require 'simplecov'
SimpleCov.start 'rails'
# Merges all tests results together, see https://github.com/colszowka/simplecov/issues/45
SimpleCov.command_name


# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }


# TODO Monkey patching for Rails 3.2.3
# See https://github.com/rails/rails/issues/6573
# See https://github.com/rails/rails/issues/4971
class ActiveSupport::TestCase
  def method_missing(selector, *args)
    if @controller.respond_to?(:_routes) &&
        @controller._routes.mounted_helpers.method_defined?(selector)
      @controller.__send__(selector, *args)
    else
      super
    end
  end
end
class ActionDispatch::IntegrationTest
  include Rails.application.routes.mounted_helpers
end


# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

# TODO Fix for integration tests
# See https://github.com/rails/rails/issues/5193
if ActionDispatch::IntegrationTest.method_defined?(:fixture_path=)
  ActionDispatch::IntegrationTest.fixture_path = File.expand_path("../fixtures", __FILE__)
end


# Configure Capybara for the integration tests
# See Capybara documentation https://github.com/jnicklas/capybara
require 'capybara/rails'
Capybara.current_driver = :selenium

# Time in seconds before trying again finding a content inside the HTML page
#Capybara.default_wait_time = 500

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
