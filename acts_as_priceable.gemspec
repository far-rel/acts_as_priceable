# -*- encoding: utf-8 -*-
require File.expand_path('../lib/acts_as_priceable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paweł Tarczykowski"]
  gem.email         = ["farrel1@wp.pl"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "acts_as_priceable"
  gem.require_paths = ["lib"]
  gem.version       = ActsAsPriceable::VERSION
end
