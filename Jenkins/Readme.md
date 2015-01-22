# Build Jenkins  docker Image 
 > build -t myjenkins_img . 

Start Jenkins Server

> docker run -d -t -h myjenkins -v /home/ebisso/Projects/Jenkins:/opt/Jenkins --name myjenkins -p 8080:8080 -v /var/jenkins_home myjenkins_img
