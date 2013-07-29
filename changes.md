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
