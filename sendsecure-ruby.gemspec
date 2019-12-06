Gem::Specification.new do |s|
  s.name        = 'sendsecure-ruby'
  s.version     = '2.0.0'
  s.date        = '2016-11-30'
  s.summary     = "sendsecure"
  s.description = "The sendsecure Ruby gem for XM SendSecure"
  s.authors     = ["XMedius R&D"]
  s.email       = 'cloud@xmedius.com'
  s.files       =  Dir.glob("{lib}/**/*")
  s.homepage    =
    'https://github.com/xmedius/sendsecure-ruby'
  s.license       = 'MIT'

  s.add_dependency "faraday", ">= 0.10.0", "< 1.0"
  s.add_dependency "faraday_middleware", ">= 0.10.1", "< 1.0"
  s.add_dependency "json", '~> 2.2', '>= 2.2.0'


  s.add_development_dependency "rspec", '~> 3.0'
  s.add_development_dependency "bundler", '~> 1.11'
  s.add_development_dependency "rake", '~> 10.0'
end

