# pjam

Smart [pinto](https://github.com/thaljef/Pinto) glue. 

pjam is glue between [pinto](http://search.cpan.org/perldoc?Pinto) and your [scm](https://en.wikipedia.org/wiki/Revision_control). 
In other words pjam is a wrapper around pinto client to create distribution archive of [perl](http://www.perl.org/) applications from source code using pinto.

# client and server 
pjam consists of two parts:
- pjam client to create distribution archives from source code using pinto.
- [pjam server](https://github.com/melezhik/jam/wiki/Introduction-to-pjam-server) to provide web interface to pjam client, so you can take some actions remotely. See [wiki pages](https://github.com/melezhik/jam/wiki/Introduction-to-pjam-server) for details.

# prerequisites and conventions 
- pinto client; `pinto` command should be in PATH. 
- subversion client; `svn` command should be in PATH.
- source codes must be strored under subversion SCM. 
- every source code should have Build.PL.


I'd like to ablish some of these in the feature and add support for me SCMs. Right now it *just fits my requirements*,
but contribution is welcome.

# installation

    gem install pjam
    
# pjam client usage example.

Full explanation can be found in [wiki pages](https://github.com/melezhik/jam/wiki/Introduction-to-pjam). 
This is brief introduction. 

## pjam project directory

First of all pjam client should be told _pjam project directory_, holding all necessary data to work with, so this is
the directory to contain all source codes and pjam configuration file:


    $ ls -1 ./hello-world-example/
    HelloWorldApp/
    HelloWorldLib/
    pjam.json


## pjam project parts

In this example there are only 2 parts (source codes) of our project - an 'application' and a 'library'. 
In real life may be much more sub elements. Both directories hold source code which should  follow [cpan distribution](http://www.dagolden.com/index.php/1173/what-tools-should-you-use-to-create-a-cpan-distribution/)
format and be stored under subversion SCM ( see the 'conventions and limitations' section ). 


## pjam project configuration file

pjam configuration file is stored in pjam project directory and describes the process of creation of distribution archive.


    $ cat ./hello-world-example/pjam.json

    {
        "stack" : "hello-world-example-stack",
        "application": "HelloWorldApp",
        "sources": [
            "HelloWorldApp",
            "HelloWorldLib"
        ]
    }

The content of configuration file is pretty self-explanatory:

- `sources` - is array of sub directories in project root directory where source codes resides. 
It is necessarily to say, that _elements in `sources` are processed in order_, if element "A" is depended 
on other element "B", than element "A" should be followed by element "B" in `sources` list.
- an `application` parameter points to the _application source directory_ - the one to make distribution from,
so all other elements in `sources` array may be treated as external dependencies for _application_ element 
and application source directory should be also in the `sources` list.

- And finally the `stack` parameter points certain pinto stack to add dependencies to. 
Of course we should create it first:


    $ pinto new hello-world-example-stack

## create distribution archive for given pjam project

Now it's time to give a try to pjam client to create distribution archive of our project, this may be done by single command:

    $ export PINTO_REPOSITORY_ROOT=/home/pinto/repo/
    $ pjam -p ./hello-world-example
    
    
    At revision 62676.
    Attempting to create directory /home/pinto/pjam-projects/hello-world-example/cpanlib
    Can't find dist packages without a MANIFEST file
    Run 'Build manifest' to generate one
    
    WARNING: Possible missing or corrupt 'MANIFEST' file.
    Nothing to enter for 'provides' field in metafile.
    add HelloWorldLib/ to pinto for the first time
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
    # ... output truncated ...
    # +[rf-] DBI::common                                         0 TIMB/DBI-1.627.tar.gz
    # +[rl-] HelloWorld::Lib                                v0.0.2 PINTO/HelloWorld-Lib-v0.0.2.tar.gz
    
    At revision 62676.
    Can't find dist packages without a MANIFEST file
    Run 'Build manifest' to generate one
    
    WARNING: Possible missing or corrupt 'MANIFEST' file.
    Nothing to enter for 'provides' field in metafile.
    add HelloWorldApp/ to pinto for the first time
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
    
    compile HelloWorldLib/
    Successfully installed DBI-1.627
    Successfully installed DBD-mysql-4.023
    Successfully installed HelloWorld-Lib-v0.0.2
    3 distributions installed
    compile HelloWorldApp/
    Successfully installed HelloWorld-App-v0.1.0
    1 distribution installed
    make distributive from HelloWorldApp/
        


After all we have all our stuff get pulled to pinto repository:

     $ pinto list -s hello-world-example-stack
     
And also we have distributive with _ALL_ dependencies inside ready to deploy:

    hello-world-example/HelloWorldApp/HelloWorld-App-v0.1.0.tar.gz
    
    

# pjam client interface

Main usage, make distribution archive:

    pjam -p <project> <options>

`project` - path to _project root directory_ (should contain pjam.json file and sub directories with sources)  

## options

- `--no-misc` - do not add miscellaneous prerequisites given by `modules` section in pjam.json file
- `--skip-pinto` - skip pinto phase, only do distribution phase, useful when prerequisites  already in pinto stack and you only
want to recreate distribution archive
- `--no-color` - do not colour output
- `--help` - print help info
- `--version` - print pjam version

## sources filter

This feature allows you to process distinct sources, while skipping others, multiple sources are separated by space when
passed to source filter parameter

`--only source-one-directory source-two-directory`

# pjam configuration file specification

    {
        "stack" : "hello-world-example-stack",
        "application": "HelloWorldApp",
        "sources": [
            "HelloWorldLib",
            "HelloWorldApp"
        ],
        "modules": [
            "DBIx::Class~0.08250",
            "Pinto"
        ]
    }

- `stack` - name of pinto stack where all prerequisites to add to
- `application` - name of sub directory in project root directory holding source code for _application_ - the one to make distribution archive from
- `sources` - is array of sub directories in project root directory  where all source codes reside. It may be treated as prerequisites 
to being added to pinto stack (pinto phase) and then to distribution archive (distribution phase)
- `modules` - is array of miscellaneous prerequisites, should follow `pinto pull` command format. It also may be treated as prerequisites 
to get pulled to pinto stack (pinto phase) and being added to distribution archive (distribution phase)


