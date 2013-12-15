# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "oa-pubcookie"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Crichton", "Stafford Brunk"]
  s.date = "2012-01-07"
  s.description = "Omniauth strategy using pubcookie with special additions for CMU students where information is fetched via LDAP"
  s.email = ["alex@crichton.co", "stafford.brunk@gmail.com"]
  s.homepage = "https://github.com/alexcrichton/oa-pubcookie"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.21"
  s.summary = "Omniauth strategy using pubcookie"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack-pubcookie>, [">= 0.0.3"])
      s.add_runtime_dependency(%q<omniauth>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<net-ldap>, [">= 0"])
      s.add_development_dependency(%q<rack>, [">= 1.4.0"])
    else
      s.add_dependency(%q<rack-pubcookie>, [">= 0.0.3"])
      s.add_dependency(%q<omniauth>, [">= 1.0.0"])
      s.add_dependency(%q<net-ldap>, [">= 0"])
      s.add_dependency(%q<rack>, [">= 1.4.0"])
    end
  else
    s.add_dependency(%q<rack-pubcookie>, [">= 0.0.3"])
    s.add_dependency(%q<omniauth>, [">= 1.0.0"])
    s.add_dependency(%q<net-ldap>, [">= 0"])
    s.add_dependency(%q<rack>, [">= 1.4.0"])
  end
end
