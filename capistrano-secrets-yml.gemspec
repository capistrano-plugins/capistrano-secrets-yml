# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "capistrano/secrets_yml/version"

Gem::Specification.new do |gem|
  gem.name          = "capistrano-secrets-yml"
  gem.version       = Capistrano::SecretsYml::VERSION
  gem.authors       = ["Bruno Sutic"]
  gem.email         = ["bruno.sutic@gmail.com"]
  gem.description   = <<-EOF.gsub(/^\s+/, "")
    Capistrano tasks for automating `secrets.yml` file handling for Rails 4+ apps.

    This plugins syncs contents of your local secrets file and copies that to
    the remote server.
  EOF
  gem.summary       = "Capistrano tasks for automating `secrets.yml` file handling for Rails 4+ apps."
  gem.homepage      = "https://github.com/capistrano-plugins/capistrano-secrets-yml"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "capistrano", ">= 3.1"
  gem.add_dependency "sshkit", ">= 1.2.0"

  gem.add_development_dependency "rake"
end
