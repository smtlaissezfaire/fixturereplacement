require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec', '--exclude', 'gems']
  t.rcov_dir = "doc/rcov"
end

desc "Feel the pain of my code, and submit a refactoring patch"
task :flog do
  puts %x(find lib | grep ".rb$" | xargs flog)
end

task :flog_to_disk => :create_doc_directory do
  puts "Flogging..."
  %x(find lib | grep ".rb$" | xargs flog > doc/flog.txt)
  puts "Done Flogging...\n"
end

def sloc
  `sloccount #{File.dirname(__FILE__)}/lib`
end

desc "Output sloccount report.  You'll need sloccount installed."
task :sloc do
  puts "Counting lines of code"
  puts sloc
end

desc "Write sloccount report"
task :output_sloc => :create_doc_directory do
  File.open(File.dirname(__FILE__) + "/doc/lines_of_code.txt", "w") do |f|
    f << sloc
  end
end
