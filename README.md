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
Let's say we store our project in our favourite scm, for now jam only supports svn, but because now it's only prototype
more scms may come soon, of-course I like git too :))


    mkdir hello-world-example
    cd  hello-world-example
    svn co http://your-svn-repository/apps/HelloWorldApp/trunk HelloWorldApp/trunk
    ls -l HelloWorldApp/trunk
    -rw-r--r-- 1 pinto pinto     1792 Jul  9 12:38 Build.PL
    drwxr-xr-x 4 pinto pinto     4096 Jul  8 15:54 lib


Jam is directory based tool, it mean you should point a directory to it to make it's work:

    jam.rb ./hello-world-example
    
Okay, I had it almost right, but I "forget" about some tiny configuration file for jam glue may do things correctly.
cat ./hello-world-example/jam.json

    {
        "stack" : "hello-world-example-stack",
        "application": "HelloWorldApp/trunk",
        "sources": [
            "HelloWorldApp/trunk",
        ]
    }

The configuration data are self explanatory. But let's clarify some of parameters. Sources - is array of directories where 
sources come from. For given example there is only one source - application itself, but there might be more, let say we want
more libraries on which our application may depend on:


    svn co http://your-svn-repository/apps/HelloWorldLib/tags/version-0.0.2 HelloWorldLib/latest-version
   

cat ./hello-world-example/jam.json

    {
        "stack" : "hello-world-example-stack",
        "application": "HelloWorldApp/trunk",
        "sources": [
            "HelloWorldLib/latest-version",
            "HelloWorldApp/trunk"
        ]
    }


It may be necessarily to say, that "sources" are processed in order, if one source code "A" is depended on other "B", 
than "A" should followed by "B" in "sources" list.


Application parameter points to directory holding application source code. When I say application I mean that final distributive 
will be based on the "application" source code, this distributive will hold:
 - all other dependencies  ( taken from "sources" list  ) 
 - and source code of application


And finally  stack is parameter to choose certain pinto stack when adding/pulling dependencies to pinto.

    pinto new hello-world-example-stack






