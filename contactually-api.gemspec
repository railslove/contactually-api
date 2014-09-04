$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'contactually/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'contactually-api'
  s.version     = Contactually::VERSION
  s.authors     = [ 'Johannes Heck' ]
  s.email       = [ 'johannes@railslove.com' ]
  s.homepage    = 'https://github.com/railslove/contactually-api'
  s.summary     = 'Contactually-API'
  s.description = 'Contactually-API'

  s.files = Dir['{lib}/**/*'] + ['LICENSE.txt', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'activesupport'
  s.add_dependency 'faraday'
  s.add_dependency 'roar'

  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
