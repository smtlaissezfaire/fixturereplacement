require 'rspec/core/rake_task'

desc 'Run the specs'
RSpec::Core::RakeTask.new do |t|
  # t.warning = false
  t.rspec_opts = ["--color"]
end
