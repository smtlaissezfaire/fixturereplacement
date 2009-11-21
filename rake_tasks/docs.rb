require 'hanna/rdoctask'

def doc_directory
  File.dirname(__FILE__) + "/../doc"
end

desc 'Generate documentation for the fixture_replacement plugin.'
Rake::RDocTask.new(:rdoc_without_analytics) do |rdoc|
  rdoc.rdoc_dir = doc_directory
  rdoc.title    = 'FixtureReplacement'
  rdoc.options << '--line-numbers' << '--inline-source'

  rdoc.options << '--webcvs=http://github.com/smtlaissezfaire/fixturereplacement/tree/master/'

  [
    "README.rdoc",
    "CHANGELOG.rdoc",
    "GPL_LICENSE",
    "MIT_LICENSE",
    "contributions.rdoc",
    "philosophy_and_bugs.rdoc",
    "lib/**/*.rb"
  ].each do |file|
    rdoc.rdoc_files.include(file)
  end
end

task :rdoc => [:rdoc_without_analytics] do
  google_analytics = File.read(File.dirname(__FILE__) + "/../etc/google_analytics")
  rdoc_index = "#{doc_directory}/index.html"

  contents = File.read(rdoc_index)
  contents.gsub!("</head>", "#{google_analytics}\n</head>")

  File.open(rdoc_index, "r+") do |file|
    file.write(contents)
  end
end

task :rerdoc => [:clobber_rdoc, :rdoc]
task :clobber_rdoc => [:clobber_rdoc_without_analytics]

def create_doc_directory
  unless File.exists?(doc_directory)
    `mkdir File.expand_path(#{doc_directory})`
  end
end

task :create_doc_directory do
  create_doc_directory
end

desc "Create the html specdoc"
Spec::Rake::SpecTask.new(:specdoc => :create_doc_directory) do |t|
  t.spec_opts = ["--format", "html:doc/specdoc.html"]
end

desc 'Create the specdoc + rdoc'
task :build_docs => [:rerdoc, :specdoc, :rcov, :flog_to_disk]
