ENV['rails'] ||= '5.0'

source 'https://rubygems.org'

gemspec path: '../'

gem 'rails', "~> #{ENV['rails']}"
gem 'doorkeeper'
gem 'dynamoid'
