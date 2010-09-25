garlic do
  # this plugin
  repo "fixturereplacement", :path => '.'

  # other repos
  repo "rails", :url => "git://github.com/rails/rails"

  # target railses
  RAILS_TAREGETS = [
    "v2.3.8",
    "v2.3.9",
    "v3.0.0"
  ]

  RAILS_TAREGETS.each do |rails|
    # declare how to prepare, and run each CI target
    target "Rails: #{rails}", :tree_ish => rails do
      prepare do
        plugin "fixturereplacement", :clone => true # so we can work in targets
      end

      run do
        cd "vendor/plugins/fixturereplacement" do
          sh "rake"
        end
      end
    end
  end
end
