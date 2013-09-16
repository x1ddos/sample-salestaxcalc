# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "salestaxcalc"

Gem::Specification.new do |s|
  s.name        = "salestaxcalc"
  s.version     = SalesTaxCalc::VERSION
  s.date        = "2013-09-16"
  s.authors     = ["alex"]
  s.email       = ["alex@cloudware.it"]
  s.homepage    = "https://github.com/crhym3/sample-salestaxcalc"
  s.license     = "MIT"
  s.summary     = "Basic sales tax calculator"
  s.description = File.open('README').read

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # optional
  s.add_development_dependency "cucumber"
  # s.add_runtime_dependency "rest-client"
end
