!# /usr/bin/env bash

# References : 
# [ 1 ] : http://stackoverflow.com/a/3706774
# [ 2 ] : https://www.ibm.com/developerworks/community/blogs/brian/entry/edit_sudoers_file_from_a_script4?lang=en  

# Input parameters : 
# $1 : full path of the sudoers file to create or update. Eg. : /etc/sudoers.d/oozie.sudo
# $2 : line to add in the sudoers file. Eg : oozie ALL=(ALL) NOPASSWD:/sbin/service start oozie
# TODO : parametrize this script and put in place command line argument parsing 
# TODO : add the possibility to pass in input a file containing all the  lines to include in a file in /etc/sudoers.d/

out_file=$1
line_to_include=$2

#
if [ -z "$out_file" ]; then

  # When you run the script without parameters, you will run this block since $1 is empty.

  echo "Starting up visudo with this script as first parameter"

  # We first set this script as the EDITOR and then starts visudo.
  # Visudo will now start and use THIS SCRIPT as its editor
  export EDITOR=$0 
  visudo
else

  # When visudo starts this script, it will provide the name of the sudoers 
  # file as the first parameter and $1 will be non-empty. Because of that, 
  # visudo will run this block.

  echo "Creating (or updating) sudoers file : [ $1 ] with content : [ $2 ]"

  # We change the sudoers file and then exit  
  echo "$line_to_include" >> $out_file
fi 
