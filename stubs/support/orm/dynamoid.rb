$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "rspec"
require 'aws-sdk'
require "aws-sdk-resources"
require "dynamoid"

ENV["ACCESS_KEY"] ||= "abcd"
ENV["SECRET_KEY"] ||= "1234"

Aws.config.update({
  region: "us-west-2",
  credentials: Aws::Credentials.new(ENV["ACCESS_KEY"], ENV["SECRET_KEY"])
})

Dynamoid.configure do |config|
  config.adapter = 'aws_sdk_v2'
  config.endpoint = "http://127.0.0.1:8000"
  config.namespace = "dynamoid_tests"
  config.warn_on_scan = false
  config.read_capacity = 5 # Read capacity for your tables
  config.write_capacity = 5 # Write capacity for your tables
end

module DynamoidReset
  def self.all
    Dynamoid.adapter.list_tables.each do |table|
      # Only delete tables in our namespace
      if table =~ /^#{Dynamoid::Config.namespace}/
        Dynamoid.adapter.delete_table(table)
      end
    end
    Dynamoid.adapter.tables.clear
    # Recreate all tables to avoid unexpected errors
    Dynamoid.included_models.each(&:create_table)
  end
end

Dynamoid.logger.level = Logger::FATAL

RSpec.configure do |config|
  config.before(:each) do
    DynamoidReset.all
  end
end
