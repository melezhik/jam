# 0.1.2
- pinto repository root now may be taken from pjam configuration file
- added override mode

# 0.1.1
- dry-run mode added

# 0.1.0
- first stable release

# 0.0.13
- `--use-default-message` option added when adding / pulling / distros 
- `--only` parameter will force skipping making distributive 
- pjam server now deals with pjam client flags via request

# 0.0.12
- small bug fixes

# 0.0.11
- fix ruby gem description

# 0.0.10
- fixing typos in help info and wiki pages

# 0.0.9
- runs pjam server under thin

# 0.0.8
- a tiny fix

# 0.0.7
- pjamd server now has config
- modules are proccessed first

# 0.0.6
- pjamd - web interface to pjam

# 0.0.5
- now can install misc modules declared in "modules" list, it's very helfull, huh?
- `skip-misc` option added
- added test as final step


# 0.0.4
- reverted some chages and cleaned up output

# 0.0.3
- rely upon `pinto install` command not cpaminus when compiling modules
- do not use local::lib directly

# 0.0.2
- `only` parameter added. Now it's possible to build distinct sources, selected by this parameter:
    
        pjam --only lib_one,lib_thee -p my_project
                
                

- now always delete distro from pinto repo before adding it; 
  this is workaround for pinto behaviour - if one once added distro to repo, he can not add it again - 
  he must delete it from repo before.

# 0.0.1
- the very first version ((:
