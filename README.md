jam
===

Smart pinto glue.

Jam is glue between pinto and your scm. Let's see on example how one can use it when building perl applications.

example
===


For the sake of simplicity let's take simple Module::Build based project we gonna gonna build with pinto.
cat Build.PL:
    
     
    #!/usr/bin/perl
    use Module::Build;
    use strict;
    my $build = Module::Build->new(
        module_name       => "HelloWorld::App",
        dist_author       => 'Alexey Melezhik / melezhik@gmail.com',
        license          => 'perl',
        configure_requires => { 'Module::Build' => '0' },
        requires         => {
          'version'    => '0',
          'DBD::mysql' => '>= 4.0.21',
          'DBI' => '0',
        },
    
        dist_abstract => 'Hello World Application',
    );

    $build->create_build_script();
    
    
  
  
