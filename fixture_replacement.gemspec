Gem::Specification.new do |s|
  s.name = %q{fixture_replacement}
  s.version = "3.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Scott Taylor"]
  s.date = %q{2009-11-21}
  s.description = %q{FixtureReplacement is a Rails plugin that provides a simple way to
quickly populate your test database with model objects without having to manage multiple,
brittle fixture files. You can easily set up complex object graphs (with models which
reference other models) and add new objects on the fly.
}
  s.email = %q{scott@railsnewbie.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG.rdoc",
     "GPL_LICENSE",
     "MIT_LICENSE",
     "README.rdoc",
     "Rakefile",
     "TODO.rdoc",
     "VERSION",
     "contributions.rdoc",
     "etc/bug_reports/2007_09_28_linoj.txt",
     "etc/google_analytics",
     "etc/patches/2007_09_14_default_model_name_with_arguments.diff",
     "etc/patches/2007_10_14_active_record_specs.diff",
     "etc/patches/2007_10_14_protected_attributes.diff",
     "etc/patches/2007_10_14_send_patch.diff",
     "etc/patches/2007_10_14_spelling_error_in_comments.diff",
     "etc/patches/2007_10_17_protected_attributes_second_go.diff",
     "etc/patches/2007_10_18_README.diff",
     "etc/patches/2007_10_19_readme_tweak.diff",
     "etc/patches/2007_10_19_silence_migration.diff",
     "etc/patches/2007_10_25_changed_classify_to_camelize.diff",
     "etc/patches/2007_11_20_fixture_replacement_generator_should_not_reload_environment_or_boot.patch",
     "etc/patches/2007_11_20_string_random_refactor_and_extension.patch",
     "etc/patches/2007_11_20_string_random_refactor_and_extension_v2.patch",
     "fixture_replacement.gemspec",
     "lib/fixture_replacement.rb",
     "lib/fixture_replacement/attribute_builder.rb",
     "lib/fixture_replacement/class_methods.rb",
     "lib/fixture_replacement/method_generator.rb",
     "lib/fixture_replacement/version.rb",
     "lib/fr.rb",
     "philosophy_and_bugs.rdoc",
     "rake_tasks/code_quality.rb",
     "rake_tasks/docs.rb",
     "rake_tasks/gem.rb",
     "rake_tasks/specs.rb",
     "rake_tasks/tests.rb",
     "rake_tasks/website.rb",
     "spec/fixture_replacement/attribute_builder_spec.rb",
     "spec/fixture_replacement/fixture_replacement_spec.rb",
     "spec/fixture_replacement/fixtures/classes.rb",
     "spec/fixture_replacement/fr_spec.rb",
     "spec/fixture_replacement/integration/attr_protected_attributes_spec.rb",
     "spec/fixture_replacement/integration/attributes_for_with_invalid_keys_spec.rb",
     "spec/fixture_replacement/integration/attributes_from_spec_without_block.rb",
     "spec/fixture_replacement/integration/create_method_spec.rb",
     "spec/fixture_replacement/integration/cyclic_dependency_spec.rb",
     "spec/fixture_replacement/integration/default_warnings_spec.rb",
     "spec/fixture_replacement/integration/extend_spec.rb",
     "spec/fixture_replacement/integration/has_and_belongs_to_many_spec.rb",
     "spec/fixture_replacement/integration/new_method_spec.rb",
     "spec/fixture_replacement/integration/private_methods_spec.rb",
     "spec/fixture_replacement/integration/public_methods_spec.rb",
     "spec/fixture_replacement/integration/valid_attributes_spec.rb",
     "spec/fixture_replacement/integration/validation_spec.rb",
     "spec/fixture_replacement/regressions/2008_01_21_random_string_with_sti_spec.rb",
     "spec/fixture_replacement/version_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/spec_helpers.rb",
     "test/test_helper.rb",
     "test/unit/user_test.rb"
  ]
  s.homepage = %q{http://replacefixtures.rubyforge.org}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{The original fixture replacement solution for rails}
  s.test_files = [
    "spec/fixture_replacement/attribute_builder_spec.rb",
     "spec/fixture_replacement/fixture_replacement_spec.rb",
     "spec/fixture_replacement/fixtures/classes.rb",
     "spec/fixture_replacement/fr_spec.rb",
     "spec/fixture_replacement/integration/attr_protected_attributes_spec.rb",
     "spec/fixture_replacement/integration/attributes_for_with_invalid_keys_spec.rb",
     "spec/fixture_replacement/integration/attributes_from_spec_without_block.rb",
     "spec/fixture_replacement/integration/create_method_spec.rb",
     "spec/fixture_replacement/integration/cyclic_dependency_spec.rb",
     "spec/fixture_replacement/integration/default_warnings_spec.rb",
     "spec/fixture_replacement/integration/extend_spec.rb",
     "spec/fixture_replacement/integration/has_and_belongs_to_many_spec.rb",
     "spec/fixture_replacement/integration/new_method_spec.rb",
     "spec/fixture_replacement/integration/private_methods_spec.rb",
     "spec/fixture_replacement/integration/public_methods_spec.rb",
     "spec/fixture_replacement/integration/valid_attributes_spec.rb",
     "spec/fixture_replacement/integration/validation_spec.rb",
     "spec/fixture_replacement/regressions/2008_01_21_random_string_with_sti_spec.rb",
     "spec/fixture_replacement/version_spec.rb",
     "spec/spec_helper.rb",
     "spec/spec_helpers.rb",
     "test/test_helper.rb",
     "test/unit/user_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
