Gem::Specification.new do |s|

  s.name        = 'pjam'
  s.version     = '0.1.3'
  s.date        = '2013-12-26'
  s.summary     = "smart pinto glue"
  s.description = "Pjam is a tool which enables automatic creation of perl applications distribution archives from source code using pinto"
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



