Gem::Specification.new do |s|
  s.name        = 'sendsecure-ruby'
  s.version     = '1.0.0'
  s.date        = '2016-11-30'
  s.summary     = "sendsecure"
  s.description = "sendsecure"
  s.authors     = ["Elise Malard"]
  s.email       = 'elise.malard@xmedius.com'
  s.files       =  Dir.glob("{lib}/**/*")
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'

  s.add_dependency "faraday", "~> 0.10.0"
  s.add_dependency "faraday_middleware", "~> 0.10.1"
  s.add_dependency "json", "~> 1.8.3"
  s.add_dependency "rspec", "~> 3.0"

  s.add_development_dependency "bundler", "~> 1.11"
  s.add_development_dependency "rake", "~> 10.0"
end

