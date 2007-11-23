require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'


desc 'Default: run unit tests.'
task :default => :spec

# Create specs + Rake Task

def doc_directory
  "doc"
end

desc 'Generate documentation for the fixture_replacement plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = doc_directory
  rdoc.title    = 'FixtureReplacement'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Run the specs'
task :spec do
  puts `spec -O spec/spec.opts #{spec_files}`
end


def spec_files
  Dir.glob("spec/fixture_replacement/*_spec.rb").collect { |f| "#{f} " }.join  
end

desc 'Create the html specdoc'
task :specdoc do
  unless File.exists?(doc_directory)
    `mkdir doc`
  end
  `spec --format html:doc/specdoc.html #{spec_files}`
end

desc 'Create the specdoc + rdoc'
task :build_docs => [:rerdoc, :specdoc]

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
  t.rcov_dir = "doc/rcov"
end
