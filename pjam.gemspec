Gem::Specification.new do |s|

  s.name        = 'pjam'
  s.version     = '0.1.1'
  s.date        = '2013-07-23'
  s.summary     = "smart pinto glue"
  s.description = "Pjam is glue between pinto and your scm. In other words pjam is a wrapper around pinto client to create distribution archive of perl applications from source code using pinto."
  s.authors     = ["Alexey Melezhik"]
  s.email       = 'melezhik@gmail.com'

  s.executables <<  'pjam'

  s.files       = %w[ lib/pjam.rb  lib/pjam-server.rb  ]

  s.license = 'MIT'
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "term-ansicolor"
  s.add_runtime_dependency "trollop"
  s.add_runtime_dependency "sinatra"
  s.homepage = 'https://github.com/melezhik/jam'

end



