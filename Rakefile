require 'bundler/setup'
require 'rake'
require 'rspec/core/rake_task'
# require 'cucumber/rake/task'
require 'appraisal'

desc "Default: Run all specs under all ActionPack supported versions."
task :default => ["appraisal:install"] do
  exec('rake appraisal spec')
end

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
end

# Cucumber::Rake::Task.new(:cucumber)

task :clobber do
  rm_rf 'pkg'
  rm_rf 'tmp'
  rm_rf 'coverage'
  rm 'coverage.data'
end

namespace :clobber do
  desc "remove generated rbc files"
  task :rbc do
    Dir['**/*.rbc'].each {|f| File.delete(f)}
  end
end