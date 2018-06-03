# frozen_string_literal: true

require 'bundler/setup'
require 'bundler/gem_tasks'

require 'rubocop/rake_task'
RuboCop::RakeTask.new do |task|
  task.options << '--display-cop-names'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

desc 'Run Fasterer'
task :fasterer do
  require 'fasterer/cli'
  Fasterer::CLI.execute
end

desc 'Check if version is fit for release'
task :check_version do
  raise 'Internal revision!' unless GVB.internal_revision.empty?
end

task test: %i[spec rubocop]
task build: %i[spec]
task release: %i[rubocop check_version]
task default: %i[test]
