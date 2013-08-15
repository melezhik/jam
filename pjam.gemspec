Gem::Specification.new do |s|

  s.name        = 'pjam'
  s.version     = '0.0.10.pre'
  s.date        = '2013-07-23'
  s.summary     = "smart pinto glue"
  s.description = "Smart pinto glue - jam between source code and pinto"
  s.authors     = ["Alexey Melezhik"]
  s.email       = 'melezhik@gmail.com'

  s.executables << 'pjam'
  s.files       = ["lib/pjam.rb"]

  s.license = 'MIT'
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "term-ansicolor"
  s.add_runtime_dependency "trollop"
  s.add_runtime_dependency "sinatra"
  s.add_runtime_dependency  "sinatra-contrib"
  s.add_runtime_dependency  "thin"
  
  s.homepage = 'https://github.com/melezhik/jam'

end



