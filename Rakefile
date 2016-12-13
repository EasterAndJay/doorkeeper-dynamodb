require 'bundler/setup'
require 'rspec/core/rake_task'

def clear_specs
  files = Dir["#{File.join(Dir.pwd, 'spec')}/**/*"]
  files.each {|f| puts f }
  # files.reject {|f|  }
  # FileUtils.rm_rf("#{base_dir}/.", secure: true) if Dir.exist?(base_dir)
end

desc 'Update Git submodules.'
task :update_submodules do
  `git submodule foreach git pull origin master`
end

task :copy_and_run_doorkeeper_specs do
  # Clear specs dir
  clear_specs
  # Copy native Doorkepeer specs
  if Dir['doorkeeper/*'].empty?
    `git submodule init`
    `git submodule update`
  end
  `cp -r -n doorkeeper/spec .`
  # Replace ORM-independent files (configs, models, etc)
  FileUtils.cp_r('spec/stubs/spec_helper_integration.rb', 'spec/spec_helper_integration.rb')
  FileUtils.cp_r('spec/stubs/models/user.rb', 'spec/dummy/app/models/user.rb')
  FileUtils.cp_r('spec/stubs/config/application.rb', 'spec/dummy/config/application.rb')
  FileUtils.cp_r('spec/stubs/support/orm/dynamoid.rb', 'spec/support/orm/dynamoid.rb')
  FileUtils.rm('spec/dummy/config/initializers/active_record_belongs_to_required_by_default.rb')
  FileUtils.rm('spec/support/orm/active_record.rb')
  # Run specs
  `bundle exec rspec`
end

desc 'Default: run specs.'
task default: :spec

desc 'Clone doorkeeper specs, prepare it for run'
task spec: :copy_and_run_doorkeeper_specs

RSpec::Core::RakeTask.new(:spec) do |config|
  config.verbose = false
end

Bundler::GemHelper.install_tasks
