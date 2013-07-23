Gem::Specification.new do |s|
  s.name        = 'layer'
  s.version     = '0.0.1.pre'
  s.date        = '2013-07-23'
  s.summary     = "smart pinto glue"
  s.description = "Smart pinto glue - layer between source code and pinto"
  s.authors     = ["Alexey Melezhik"]
  s.email       = 'melezhik@gmail.com'

  s.add_runtime_dependency "json"
  s.add_development_dependency "term-ansicolor"
  s.add_development_dependency "trollop"

  s.executables << 'layer'
  s.homepage    =
    'https://github.com/melezhik/jam'
end


