require 'rake'

Dir.glob("rake_tasks/**/*.rb").each do |file|
  require file
end

desc 'Default: run unit tests (specs + tests).'
task :default => [:spec, :test]
