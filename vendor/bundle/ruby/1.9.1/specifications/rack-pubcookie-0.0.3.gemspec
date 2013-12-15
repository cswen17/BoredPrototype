# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rack-pubcookie"
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Crichton"]
  s.date = "2011-01-19"
  s.description = "Pubcookie finally leaves the world of apache!"
  s.email = ["alex@alexcrichton.com"]
  s.homepage = "http://github.com/alexcrichton/rack-pubcookie"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.21"
  s.summary = "An implentation of pubcookie based on Rack in Ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end
