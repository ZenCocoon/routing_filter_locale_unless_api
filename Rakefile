require 'bundler/setup'
require 'rake'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'appraisal'

desc "Default: Run all specs and cucumber features under all supported Rails versions."
task :default => ["appraisal:install"] do
  exec('rake appraisal spec cucumber')
end

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
end

Cucumber::Rake::Task.new(:cucumber)
