# pjam

Smart [pinto](https://github.com/thaljef/Pinto) glue. 

pjam is glue between [pinto](http://search.cpan.org/perldoc?Pinto) and your [scm](https://en.wikipedia.org/wiki/Revision_control). 
pjam is a wrapper around pinto client to automatically create distribution archive of [perl](http://www.perl.org/) applications from source code using pinto.

# client and server
 
pjam consists of two parts:
- pjam client to create distribution archives from source code using pinto. all job can be done with the pjam client.
- [pjam server](https://github.com/melezhik/jam/wiki/Introduction-to-pjam-server) to provide web interface to pjam client, so you can take some actions remotely. 

# prerequisites and conventions 
- pinto client; `pinto` command should be in PATH. 
- subversion client; `svn` command should be in PATH.
- source codes ( build parts, see further ) must be stored under subversion SCM. 
- every source code directory should have Build.PL file.


I'd like to abolish some of these limitations in the feature, right now it *just fits my requirements*, but any contribution is welcome.

# installation

    gem install pjam
    
# pjam client usage example

First of all let's understand a few simple things about pinto client architecture.

## pjam project 

Pjam client is a project  centric or directory centric tool. All data necessary to build distribution archive should be  placed in single directory, called _project root directory_ and this directory represents _pjam project_. Every pjam project  will 'produce' a single distribution archive. You may have many pjam projects to create many distribution archives.

 ## project root directory

_Project root directory_ ( root directory in short ) is the directory containing all necessary data to build distribution archive from your source code. These ones are:

     1. sub directories with source codes, aka  build parts ( see further )
     2. pjam configuration file

Root directory layout may look like:

    $ tree -L 2  ./hello-world-example/
    HelloWorldApp/ # build part number 1, an application source code
         Build.PL
         lib/
         scripts/
         ...
    HelloWorldLib/ # build part number 2, a library source code 
         Build.PL
         lib/
         ...
    pjam.json # pjam configuration file 


## build parts

Build parts - are number of directories holding source code to build your application distribution archive with. Every build part should have valid Build.PL file in it.  In the example given there are two build parts -  an  'application' ( HelloWorldApp directory ) and a 'library' ( HelloWorldLib directory ). 
In real life applications may be much more build parts. Both directories hold valid Build.PL files to  satisfy [cpan distribution](http://www.dagolden.com/index.php/1173/what-tools-should-you-use-to-create-a-cpan-distribution/) requirements and are kept by subversion SCM.

## configuration file

pjam configuration file is stored in the root directory and describes the process of distribution archive creation.


    $ cat ./hello-world-example/pjam.json

    {
        "repository" : "/var/pinto/repos/hello-world-example",
        "application": "HelloWorldApp",
        "sources": [
            "./HelloWorldApp",
            "./HelloWorldLib"
        ]
    }

The content of configuration file is pretty self-explanatory:

- `sources` - is array of build parts of the project, technically speaking  these are sub directories in the project root directory. 
It is necessarily to say, that  build parts in `sources` _are processed in order_, if build part "A" is depended 
on other build part  "B", than  "A" should be followed by "B" in `sources` list.

- an `application` parameter points to the _distribution part_ -  the build part to make distribution from.
So all build parts in `sources` array are dependencies to be included in distribution archive. And _distribution part_  is the source code to be used to create distribution archive from.

-  a `repository` parameter points to the pinto repository to download external dependencies ( cpan modules ) from.

Check out pinto documentation for details. 

Before start to create distribution  archive we should create pinto repository and optionally a stack, if we do not want to use default one:

    $ pinto --root init /var/pinto/repos/hello-world-example

## create distribution archive

Now it's time to give a try to pjam client to create distribution archive from our project:

    $ cd hello-world-example 
    $ pjam
        

Now we have all our stuff get pulled to pinto repository and ready to used distribution archive hello-world-example/HelloWorldApp/HelloWorld-App-v0.1.0.tar.gz

     $ pinto -r  /var/pinto/repos/hello-world-example list 

# pjam client command line interface 

Main usage, make distribution archive:

    pjam -p <project> <options>

- `project` - path to _project root directory_ 

## options

- `--no-misc` - do not add miscellaneous prerequisites given by `modules` section in pjam.json file
- `--skip-pinto` - skip pinto phase, only do distribution creation phase, useful when prerequisites  already in pinto stack and you only
want to recreate distribution archive
- `--no-color` - do not colour output
- `--help` - print help info
- `--version` - print pjam version

## build parts filter

This feature allows you to process only given build parts ( and skip others ), multiple build parts, separated by space are passed with `only` parameter:

`--only build-part-one build-part-two`

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

-  `repository` - a pinto repository to download external dependencies ( cpan modules ) from.
- `stack` - name of pinto stack in pinto repository ( given by `repository` parameter ), `default` if not set.
- `application` -  the name of  _distribution part_ -  the build part to make distribution from.
- `sources` - is array of build parts.
- `modules` - is array of miscellaneous prerequisites, should follow `pinto pull` command format.  Modules get pulled to pinto repository ( during pinto phase ) and being added to distribution archive ( during distribution create phase ).

