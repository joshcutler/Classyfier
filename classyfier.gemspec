# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "classyfier/version"

Gem::Specification.new do |s|
  s.name        = "classyfier"
  s.version     = Classyfier::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Josh Cutler"]
  s.email       = ["josh@codepresencelabs.com"]
  s.homepage    = ""
  s.summary     = %q{Simple Naive Bayesian Classifier}
  s.description = %q{Simple Naive Bayesian Classifier}

  s.rubyforge_project = "classyfier"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
