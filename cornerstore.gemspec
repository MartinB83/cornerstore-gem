# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cornerstore/version'

Gem::Specification.new do |gem|
  gem.name          = "cornerstore"
  gem.version       = Cornerstore::VERSION
  gem.authors       = ['Johannes Treitz', 'Christian Weyer']
  gem.email         = ['jt@crispymtn.com', 'cw@crispymtn.com']
  gem.description   = "This is a client for the Cornerstore e-commerce API"
  gem.summary       = "This is a client for the Cornerstore e-commerce API"
  gem.homepage      = "https://www.github.com/crispymtn/cornerstore-gem"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rest-client'
  gem.add_dependency 'activemodel'
  gem.add_development_dependency "rspec"

end
