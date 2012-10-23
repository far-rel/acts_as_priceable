# -*- encoding: utf-8 -*-
require File.expand_path('../lib/acts_as_priceable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paweł Tarczykowski"]
  gem.email         = ["farrel1@wp.pl"]
  gem.description   = "Acts as priceable"
  gem.summary       = "Acts as priceable"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "acts_as_priceable"
  gem.require_paths = ["lib"]
  gem.version       = ActsAsPriceable::VERSION
  gem.add_dependency "activerecord", ">= 3.0.0"
  gem.add_dependency "bigdecimal", "~> 1.1.0"
  gem.add_development_dependency 'rspec', "~> 2.10.0"
end
