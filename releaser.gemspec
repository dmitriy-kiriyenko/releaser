# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "releaser/version"

Gem::Specification.new do |s|
  s.name        = "releaser"
  s.version     = Releaser::VERSION
  s.authors     = ["Dmitriy Kiriyenko"]
  s.email       = ["dmitriy.kiriyenko@anahoret.com"]
  s.homepage    = ""
  s.summary     = %q{A set of thor scripts for managing application versions}
  s.description = %q{A set of thor scripts for managing application versions.
                     Use it to control and even display your application current version.}

  s.rubyforge_project = "releaser"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "railties"
end
