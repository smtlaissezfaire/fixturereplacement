require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'rake/contrib/rubyforgepublisher'

desc 'Default: run unit tests.'
task :default => :spec

# Create specs + Rake Task

def doc_directory
  "doc"
end

desc 'Generate documentation for the fixture_replacement plugin.'
Rake::RDocTask.new(:rdoc_without_analytics) do |rdoc|
  rdoc.rdoc_dir = doc_directory
  rdoc.title    = 'FixtureReplacement'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :rdoc => [:rdoc_without_analytics] do
  google_analytics = File.read(File.dirname(__FILE__) + "/etc/google_analytics")
  rdoc_index = File.dirname(__FILE__) + "/#{doc_directory}/index.html"
  
  contents = File.read(rdoc_index) 
  contents.gsub!("</head>", "#{google_analytics}\n</head>")

  File.open(rdoc_index, "r+") do |file|
    file.write(contents)
  end

end

task :rerdoc => [:clobber_rdoc, :rdoc]
task :clobber_rdoc => [:clobber_rdoc_without_analytics]

desc 'Run the specs'
task :spec do
  puts `spec -O spec/spec.opts #{spec_files}`
end

desc 'Publish the website, building the docs first'
task :publish_website => [:build_docs] do
  publisher = Rake::SshDirPublisher.new(
    "smtlaissezfaire@rubyforge.org",
    "/var/www/gforge-projects/replacefixtures/",
    "doc"
  )
  publisher.upload
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
task :build_docs => [:rerdoc, :specdoc, :rcov]

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
  t.rcov_dir = "doc/rcov"
end
