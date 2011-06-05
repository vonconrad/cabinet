# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cabinet/version"

Gem::Specification.new do |s|
  s.name        = "cabinet"
  s.version     = Cabinet::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sebastian von Conrad"]
  s.email       = ["sebastian@vonconrad.com"]
  s.homepage    = "http://github.com/vonconrad/cabinet"
  s.summary     = %q{Wrapper for local and cloud file handling via fog}
  s.description = %q{Cabinet is a wrapper for fog to add a simplified way of handling files, both in the cloud and on the local filesystem}

  s.rubyforge_project = "cabinet"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "fog", "~> 0.8.2"
  s.add_development_dependency "rspec", "~> 2.3.0"
  s.add_development_dependency "forgery"
  s.add_development_dependency "fuubar"
end
