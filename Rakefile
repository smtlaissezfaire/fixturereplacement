require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :spec

# Create specs + Rake Task

desc 'Generate documentation for the fixture_replacement plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'FixtureReplacement'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :spec do
  files = Dir.glob("spec/fixture_replacement/*_spec.rb").collect { |f| "#{f} " }.join
  puts `spec -O spec/spec.opts #{files}`
end
