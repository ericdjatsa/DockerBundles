#!/usr/bin/env bash

# Run git-ssh server

# Remove previous instances
docker rm mygit-ssh
#Run it 
docker run -p 2222:22 -h mygit-ssh -d  -v /home/git/repositories --name mygit-ssh --link myjenkins:myjenkins git-ssh_img 

