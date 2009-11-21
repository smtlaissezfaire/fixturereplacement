require 'rake/contrib/rubyforgepublisher'

desc 'Publish the website, building the docs first'
task :publish_website => [:build_docs] do
  publisher = Rake::SshDirPublisher.new(
    "smtlaissezfaire@rubyforge.org",
    "/var/www/gforge-projects/replacefixtures/",
    "doc"
  )
  publisher.upload
end
