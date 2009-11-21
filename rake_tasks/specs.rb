require 'spec/rake/spectask'

desc 'Run the specs'
Spec::Rake::SpecTask.new do |t|
  t.warning = false
  t.spec_opts = ["--color"]
end
