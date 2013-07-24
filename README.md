pjam
===
Smart [pinto](https://github.com/thaljef/Pinto) glue. 

pjam is glue between pinto and your [scm](https://en.wikipedia.org/wiki/Revision_control). See an example further on how one can use layer and pinto to build [perl](http://www.perl.org/) applications.


prerequisites
===
pinto client should be installed, pjam should be run on the same environment as pinto does. PINTO_REPOSITORY_ROOT and
PINTO_EDITOR should be set as shown in example.


example
===

First of all  checkout and install pjam from git repository:

    gem install pjam --pre --no-ri --no-rdoc
    

For the sake of simplicity let's take a simple [Module::Build](http://search.cpan.org/perldoc?Module%3A%3ABuild) based project, we gonna build with pinto.
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
    
    
  
As you can see there are some prerequisites - version, DBD::mysql, DBI - we will let pinto to take care about all of them.
Also, let's say we store our project source code in our favourite scm, for the example given it is [SVN](http://subversion.tigris.org), 
pjam now in prototype stage, but in the future more scms may be supported, of-course I like [git](http://git-scm.com/) too :))

    mkdir pjam-projects
    cd pjam-projects
    mkdir hello-world-example
    cd  hello-world-example
    svn co http://your-svn-repository/apps/HelloWorldApp/trunk HelloWorldApp/trunk
    ls -l HelloWorldApp/trunk
    -rw-r--r-- 1 pinto pinto     1792 Jul  9 12:38 Build.PL
    drwxr-xr-x 4 pinto pinto     4096 Jul  8 15:54 lib


pjam is directory based tool, it mean you should point a directory to to make it work:

    pjam -p ./hello-world-example
    
Okay, I had it almost right, but I "forget" about some tiny configuration file for pjam may glue things correctly. This is
pjam json file. cat ./hello-world-example/layer.json

    {
        "stack" : "hello-world-example-stack",
        "application": "HelloWorldApp/trunk",
        "sources": [
            "HelloWorldApp/trunk",
        ]
    }

The configuration data are pretty self-explanatory. But let's clarify some of parameters. Sources - is array of directories where 
source code comes from. Right now there is only one source - application source code, but there might be more, what if we want
more libraries on which our application code may depend on ? It's easy to add one: 


    svn co http://your-svn-repository/apps/HelloWorldLib/tags/version-0.0.2 HelloWorldLib/latest-version
   
Now we need to add new source to pjam json file. cat ./hello-world-example/layer.json

    {
        "stack" : "hello-world-example-stack",
        "application": "HelloWorldApp/trunk",
        "sources": [
            "HelloWorldLib/latest-version",
            "HelloWorldApp/trunk"
        ]
    }


It is necessarily to say, that _elements in "sources" are processed in order_, if one source code "A" is depended on other "B", 
than "A" should be followed by "B" in "sources" list.


Application parameter points to the directory that will be choosen to make distibutive from. 
After all the distribuitve will hold all dependencies taken from "sources" list + source code in application "directory"

And finally the stack parameter points certain pinto stack when adding/pulling dependencies to pinto. Of-course
we should create it before:

    pinto new hello-world-example-stack

Now, let's try our smart pjam glue to build our application:

    export PINTO_EDITOR=cat
    export PINTO_REPOSITORY_ROOT=/home/pinto/repo2/

    pjam -p ./hello-world-example
    
    At revision 62676.
    Attempting to create directory /home/pinto/pjam-projects/hello-world-example/cpanlib
    Can't find dist packages without a MANIFEST file
    Run 'Build manifest' to generate one
    
    WARNING: Possible missing or corrupt 'MANIFEST' file.
    Nothing to enter for 'provides' field in metafile.
    add HelloWorldLib/latest-version to pinto for the first time
    Registering PINTO/HelloWorld-Lib-v0.0.2.tar.gz on stack hello-world-example-stack
    Descending into prerequisites for PINTO/HelloWorld-Lib-v0.0.2.tar.gz
    Add PINTO/HelloWorld-Lib-v0.0.2.tar.gz
    
    
    #-------------------------------------------------------------------------------
    # Please edit or amend the message above as you see fit.  The first line of the 
    # message will be used as the title.  Any line that starts with a "#" will be 
    # ignored.  To abort the commit, delete the entire message above, save the file, 
    # and close the editor. 
    #
    # Changes to be committed to stack hello-world-example-stack:
    #
    # +[rf-] Bundle::DBD::mysql                              4.004 CAPTTOFU/DBD-mysql-4.023.tar.gz
    # +[rf-] DBD::mysql                                      4.023 CAPTTOFU/DBD-mysql-4.023.tar.gz
    # +[rf-] DBD::mysql::GetInfo                                 0 CAPTTOFU/DBD-mysql-4.023.tar.gz
    # +[rf-] DBD::mysql::db                                      0 CAPTTOFU/DBD-mysql-4.023.tar.gz
    # +[rf-] DBD::mysql::dr                                      0 CAPTTOFU/DBD-mysql-4.023.tar.gz
    # +[rf-] DBD::mysql::st                                      0 CAPTTOFU/DBD-mysql-4.023.tar.gz
    # +[rf-] Bundle::DBI                                 12.008695 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::DBM                                         0.08 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::DBM::Statement                                 0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::DBM::Table                                     0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::DBM::db                                        0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::DBM::dr                                        0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::DBM::st                                        0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::ExampleP                               12.014310 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::ExampleP::db                                   0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::ExampleP::dr                                   0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::ExampleP::st                                   0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::File                                        0.41 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::File::DataSource::File                         0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::File::DataSource::Stream                       0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::File::Statement                                0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::File::Table                                    0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::File::TableSource::FileSystem                  0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::File::db                                       0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::File::dr                                       0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::File::st                                       0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer                                   0.015326 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::Policy::Base                     0.010087 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::Policy::classic                  0.010087 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::Policy::pedantic                 0.010087 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::Policy::rush                     0.010087 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::Transport::Base                  0.014120 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::Transport::corostream                   0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::Transport::null                  0.010087 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::Transport::pipeone               0.010087 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::Transport::stream                0.014598 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::db                                      0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::dr                                      0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Gofer::st                                      0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::NullP                                  12.014714 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::NullP::db                                      0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::NullP::dr                                      0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::NullP::st                                      0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Proxy                                     0.2004 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Proxy::RPC::PlClient                           0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Proxy::db                                      0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Proxy::dr                                      0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Proxy::st                                      0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Sponge                                 12.010002 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Sponge::db                                     0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Sponge::dr                                     0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBD::Sponge::st                                     0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBDI                                                0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI                                             1.627 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Const::GetInfo::ANSI                    2.008696 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Const::GetInfo::ODBC                    2.011373 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Const::GetInfoReturn                    2.008696 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Const::GetInfoType                      2.008696 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD                                    12.015128 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD::Metadata                           2.014213 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD::SqlEngine                              0.06 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD::SqlEngine::DataSource                     0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD::SqlEngine::Statement                      0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD::SqlEngine::Table                          0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD::SqlEngine::TableSource                    0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD::SqlEngine::TieMeta                        0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD::SqlEngine::TieTables                      0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD::SqlEngine::db                             0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD::SqlEngine::dr                             0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::DBD::SqlEngine::st                             0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::FAQ                                     1.014934 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Gofer::Execute                          0.014282 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Gofer::Request                          0.012536 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Gofer::Response                         0.011565 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Gofer::Serializer::Base                 0.009949 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Gofer::Serializer::DataDumper           0.009949 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Gofer::Serializer::Storable             0.015585 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Gofer::Transport::Base                  0.012536 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Gofer::Transport::pipeone               0.012536 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Gofer::Transport::stream                0.012536 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Profile                                 2.015064 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::ProfileData                             2.010007 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::ProfileDumper                           2.015324 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::ProfileDumper::Apache                   2.014120 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::ProfileSubs                             0.009395 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::ProxyServer                               0.3005 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::ProxyServer::db                                0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::ProxyServer::dr                                0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::ProxyServer::st                                0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::PurePerl                                2.014285 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::SQL::Nano                               1.015543 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::SQL::Nano::Statement_                          0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::SQL::Nano::Table_                              0 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::Util::CacheMemory                       0.010314 TIMB/DBI-1.627.tar.gz
    # +[rf-] DBI::common                                         0 TIMB/DBI-1.627.tar.gz
    # +[rl-] HelloWorld::Lib                                v0.0.2 PINTO/HelloWorld-Lib-v0.0.2.tar.gz
    
    At revision 62676.
    Can't find dist packages without a MANIFEST file
    Run 'Build manifest' to generate one
    
    WARNING: Possible missing or corrupt 'MANIFEST' file.
    Nothing to enter for 'provides' field in metafile.
    add HelloWorldApp/trunk to pinto for the first time
    Registering PINTO/HelloWorld-App-v0.1.0.tar.gz on stack hello-world-example-stack
    Descending into prerequisites for PINTO/HelloWorld-App-v0.1.0.tar.gz
    Add PINTO/HelloWorld-App-v0.1.0.tar.gz
    
    
    #-------------------------------------------------------------------------------
    # Please edit or amend the message above as you see fit.  The first line of the 
    # message will be used as the title.  Any line that starts with a "#" will be 
    # ignored.  To abort the commit, delete the entire message above, save the file, 
    # and close the editor. 
    #
    # Changes to be committed to stack hello-world-example-stack:
    #
    # +[rl-] HelloWorld::App                                v0.1.0 PINTO/HelloWorld-App-v0.1.0.tar.gz
    
    compile HelloWorldLib/latest-version
    Successfully installed DBI-1.627
    Successfully installed DBD-mysql-4.023
    Successfully installed HelloWorld-Lib-v0.0.2
    3 distributions installed
    compile HelloWorldApp/trunk
    Successfully installed HelloWorld-App-v0.1.0
    1 distribution installed
    make distributive from HelloWorldApp/trunk
        


After all we have all our stuff get pulled to pinto repository:

     pinto list -s hello-world-example-stack
     
And also we have distributive with _ALL_ dependencies ready to use:

    hello-world-example/HelloWorldApp/trunk/HelloWorld-App-v0.1.0.tar.gz
    
    



