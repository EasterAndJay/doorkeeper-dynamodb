$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "doorkeeper-dynamodb/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "doorkeeper-dynamodb"
  s.version     = DoorkeeperDynamodb::VERSION
  s.authors     = ["earlonrails"]
  s.email       = ["earlkrauss@gmail.com"]
  s.homepage    = "http://github.com/doorkeeper-gem/doorkeeper-dynamodb"
  s.summary     = "Doorkeeper dynamoid ORMs"
  s.description = "Doorkeeper dynamoid ORMs"
  s.license     = "MIT"

  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "doorkeeper"
  s.add_dependency "dynamoid"

  s.add_development_dependency "sqlite3", "~> 1.3.5"
  s.add_development_dependency "rspec-rails", "~> 3.4.0"
  s.add_development_dependency "capybara", "~> 2.3.0"
  s.add_development_dependency "generator_spec", "~> 0.9.0"
  s.add_development_dependency "factory_girl", "~> 4.5.0"
  s.add_development_dependency "timecop", "~> 0.7.0"
end
