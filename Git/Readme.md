# Source : [ http://www.florentflament.com/blog/git-ssh-docker-container.html ]

# Build the container
> docker build -t git-ssh_img .

# Run git-ssh server
> docker rm mygit-ssh
 
 > docker run -p 2222:22 -h mygit-ssh -d -v /home/git/repositories --name mygit-ssh --link myjenkins:myjenkins  git-ssh_img 

