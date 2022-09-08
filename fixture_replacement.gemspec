Gem::Specification.new do |s|
  s.name = %q{fixture_replacement}
  s.version = "4.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Scott Taylor", "Stephen Schor"]
  s.date = %q{2022-09-07}
  s.description = %q{FixtureReplacement is a Rails plugin that provides a simple way to
quickly populate your test database with model objects without having to manage multiple,
brittle fixture files. You can easily set up complex object graphs (with models which
reference other models) and add new objects on the fly.
}
  s.email = %q{scott@railsnewbie.com beholdthepanda@gmail.com}
  s.files = Dir[
    "{lib}/**/*.rb",
    "*.rdoc",
    "GPL_LICENSE",
    "MIT_LICENSE",
    "VERSION",
  ]
  s.homepage = %q{https://github.com/smtlaissezfaire/fixturereplacement}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{The original fixture replacement solution for rails}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
