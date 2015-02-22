# The OOZIE_URL parameter is defined in the Dockerfile as 
# ENV http://master:11000/oozie
# For it to work, 
# The the master container (the one running OOzie server - eric.djatsa/cdh5hadoopmaster_oozie ) should be linked
# to this slave container using the name 'master' 
 
