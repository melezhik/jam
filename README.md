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
    
    
  
As you can see there are some prerequisites - version, DBD::mysql, DBI - but let pinto take care about them.
Let's say we store out project in our favourite scm, for now jam only supports svn, but because it's only prototype
more scms may come soon, ofcourse I like git too :))


    mkdir hello-world
    svn co http://your-svn-repository/apps/HelloWorldApp/ HelloWorldApp
    ls -l HelloWorldApp
    -rw-r--r-- 1 pinto pinto     1792 Jul  9 12:38 Build.PL
    drwxr-xr-x 4 pinto pinto     4096 Jul  8 15:54 lib



