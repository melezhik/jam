# pjam

Smart [pinto](https://github.com/thaljef/Pinto) glue. 

Pjam is the tool which  enables *automatic* creation of  [perl](http://www.perl.org/) applications distribution archives from source code kept under [subversion scm](http://subversion.tigris.org/) using [pinto](http://search.cpan.org/perldoc?Pinto).

# client and server
Pjam consists of two parts: pjam client  - is the command line utility to take all operations and [pjam server](https://github.com/melezhik/jam/wiki/Introduction-to-pjam-server) to provide remote access to pjam client with limited api. 

# prerequisites and conventions 
- pinto client should be installed; `pinto` command should be in PATH. 
- subversion client should be installed; `svn` command should be in PATH.
- source codes must be stored under subversion SCM. 
- every source code directory should have Build.PL file.


I'd like to abolish some of these limitations in the feature, right now it *just fits my requirements*, but any contribution is welcome.

# installation

    gem install pjam
    
# pjam client usage

First of all let's understand a few simple things about pjam architecture.

## pjam project 
Pjam client is the directory centric  tool. All data necessary to build distribution archive should be  placed in single directory, called _project root directory_ hereby this directory represents _pjam project_. Every pjam project  hereby _produce_ a single distribution archive. You may have as many pjam projects as you want to create various distribution archives. Project root directory contains two logical data parts:

## sources
Sources are sub directories inside project root directory with source codes to build distribution archive from. Every source directory should valid Build.PL files to  satisfy [cpan distribution](http://www.dagolden.com/index.php/1173/what-tools-should-you-use-to-create-a-cpan-distribution/) requirements and be kept by subversion SCM. Sources are non*CPAN dependencies to be included in distribution archive. CPAN dependencies are declared in standard way  in Build.PL files in every source directory.

## configuration file
Configuration file is stored in the root directory and describes the process of distribution archive creation.

## build phases
When pjam start to create distribution archive, it does it in two phases:

### pinto phase
First of all pjam collect all dependencies information, stored in sources directories and add them into pinto repository.

### distribution phase
Then if everything is ok with pinto phase and no errors are occurred, pjam 
starts distribution archive creation, all the dependencies are get fetched from pinto repository and install locally, if installation is ok, distribution archive is created including all locally installed modules.


# hello world example
First, let's create project root directory and add some sources:

    $ mkdir  my-application
    $ cd my-application 
    $ svn co  http://svn.repo/my-app/trunk application
    $ svn co  http://svn.repo/lib/my-cute-lib/trunk lib

Then create configuration file:

    $ nano pjam.json 

    {
        "repository" : "/var/pinto/repos/my-repo",
        "application": "application",
        "sources": [
            "lib",
            "application"
        ]
    }

The content of configuration file is pretty self-explanatory:

### repository
The repository parameter points to the pinto repository to download external dependencies ( CPAN modules ) from. Before we start create distribution archive we should create pinto repository and optionally a stack:

    $ pinto --root init /var/pinto/repos/my-repo
 
Check out [pinto documentation](http://search.cpan.org/perldoc?Pinto%3A%3AManual%3A%3ATutorial) to get know what pinto stacks and repositories are. 

### sources 
The source parameter is the array of sources directories, they should be  sub directories of the project root directory.  It is necessarily to say, that  sources in `sources` array _are processed in order_, so if source "A" is _depended_ on source  "B" ( has perl module dependencies, defined in "B" ), than  "A" should be followed by "B" in `sources` list.

### application
The application parameter points to the source directory to make distribution from. 


## create distribution archive using pjam

Now we are ready to create distribution archive based on our project, using pjam power:

    $ cd my-application
    $ pjam
        

Now we have  distribution archive located at application/my-app.v0.1.0.tar.gz with all our dependencies  taken from pinto repository:

     $ pinto -r  /var/pinto/repos/my-repo list 


# pjam client command line interface 

Main usage, make distribution archive:

    $ pjam <options>

## options

- `-p` path to project root directory, if not set current working, project root directory is equal current working directory.

- `--no-misc` - do not add miscellaneous prerequisites declared in `modules` section in pjam.json file.

- `--skip-pinto` - skip pinto phase, do only distribution create phase, useful when prerequisites  already in pinto repository and you only want to create distribution archive.

- `--no-color` - disable color output

- `--help` - print help info

- `--version` - print pjam version

# sources filter

This feature allows you to process only given sources  ( and skip others ), multiple sources may be  passed via `only` parameter, using comma separator

`--only 'lib1 lib2 lib10'`

# pjam configuration file specification

    {
       "repository" : "my-repo",
        "stack" : "my-stack",
        "application": "app",
        "sources": [
            "library",
            "app"
        ],
        "modules": [
            "DBIx::Class~0.08250",
            "Pinto"
        ]
    }

- `repository` - a pinto repository to download external dependencies ( cpan modules ) from.
- `stack` - name of pinto stack in pinto repository ( given by `repository` parameter ), `default` if not set.
- `application` -  the name of  source directory to make distribution from.
- `sources` - is array of sources.
- `modules` - is array of miscellaneous prerequisites, should follow `pinto pull` command format.  Modules get pulled to pinto repository ( during pinto phase ) and being added to distribution archive ( during distribution create phase ).

