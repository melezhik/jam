Gem::Specification.new do |s|
  s.name        = 'jam'
  s.version     = '0.0.1'
  s.date        = '2013-07-23'
  s.summary     = "smart pinto glue"
  s.description = "Smart pinto glue - layer between source code and pinto"
  s.authors     = ["Alexey Melezhik"]
  s.email       = 'melezhik@gmail.com'

  s.add_runtime_dependency "json"
  s.add_development_dependency "term-ansicolor"
  s.add_development_dependency "trollop"

  s.executables << 'jam'
  s.homepage    =
    'https://github.com/melezhik/jam'
end

