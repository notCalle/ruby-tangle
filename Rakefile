require 'bundler/setup'
require 'bundler/gem_tasks'

require 'rubocop/rake_task'
RuboCop::RakeTask.new do |task|
  task.options << '--display-cop-names'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

task default: %i[rubocop spec]
desc 'Run Fasterer'
task :fasterer do
  require 'fasterer/cli'
  Fasterer::CLI.execute
end
