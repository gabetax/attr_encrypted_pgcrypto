# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attr_encrypted_pgcrypto/version'

Gem::Specification.new do |gem|
  gem.name          = "attr_encrypted_pgcrypto"
  gem.version       = AttrEncryptedPgcrypto::VERSION
  gem.authors       = ["Gabe Martin-Dempesy"]
  gem.email         = ["gabe@mudbugmedia.com"]
  gem.description   = %q{A pgcrypto based Encryptor implementation for attr_encrypted}
  gem.summary       = %q{A pgcrypto based Encryptor implementation for attr_encrypted}
  gem.homepage      = "https://github.com/gabetax/attr_encrypted_pgcrypto"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec', '~> 2.12.0'
  gem.add_development_dependency 'pg',    '~> 0.14.0'
end
