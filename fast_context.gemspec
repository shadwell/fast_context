Gem::Specification.new do |s|
  s.name = %q{fast_context}
  s.version = "1.0.0.pp"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ari Russo"]
  s.email = %q{ari@paperlesspost.com}
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README.md",
     "VERSION",
     "lib/fast_context.rb",
     "lib/init.rb"
  ]
  s.homepage = %q{https://github.com/paperlesspost/fast_context}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{This is a fork of the fast_context plugin}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<shoulda-context>, ["~> 1.2", ">= 1.2.1"])
    else
      s.add_dependency(%q<shoulda-context>, ["~> 1.2", ">= 1.2.1"])
    end
  else
    s.add_dependency(%q<shoulda-context>, ["~> 1.2", ">= 1.2.1"])
  end
end
