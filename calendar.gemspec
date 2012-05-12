$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "calendar/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "calendar"
  s.version     = Calendar::VERSION
  s.authors     = ["Tanguy Krotoff"]
  s.email       = ["tkrotoff@gmail.com"]
  s.homepage    = "https://github.com/tkrotoff/fullcalendar-rails-engine"
  s.summary     = "FullCalendar Ruby on Rails mountable engine."
  s.description = "A Google Calendar like mountable engine for Ruby on Rails."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 3.2.3'
  s.add_dependency 'jquery-rails'

  s.add_dependency 'sass-rails'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'simple_form'

  s.add_development_dependency 'sqlite3'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'launchy'
end
