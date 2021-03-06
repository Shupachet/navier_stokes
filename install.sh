#!/bin/sh
# this script will
#   i) Pull OpenFOAM+ from docker hub if it does not exist in local environment 
#  ii) Create  container with name of_v1606_plus
# iii) PostProcessing Tool : paraview/paraFoam
#  iv) Image comes with already installed utility:
#      Midnight Commander, gnuplot 
#   v) This script has been tested upto 1.12 docker version 
#    Note: Docker daemon should be running before  launching script 
username="$USER"
user="$(id -u)"
home="${1:-$HOME}"

imageName="openfoamplus/of_v1606plus_centos66"
containerName="of_v1606_plus"   
displayVar="$DISPLAY"
# find container already created are running:
echo "Following Docker containers are present on your system:"
echo "**************************************** "
docker ps -a 


#creating docker container for OpenFOAM+ operation   
echo "**************************************** "
echo "			"
echo "Creating Docker OpenFOAM+ container ${containerName}"

docker run  -it -d --name ${containerName} --user=${user} -e USER=${username} -e QT_X11_NO_MITSHM=1 -e DISPLAY=${displayVar} --workdir="${home}" --volume="${home}:${home}"  --volume="/etc/group:/etc/group:ro"  --volume="/etc/passwd:/etc/passwd:ro"  --volume="/etc/shadow:/etc/shadow:ro"  --volume="/etc/sudoers.d:/etc/sudoers.d:ro" -v=/tmp/.X11-unix:/tmp/.X11-unix  ${imageName}  /bin/bash --rcfile /opt/OpenFOAM/setImage_v1606+

echo "Container ${containerName} was created."

echo "**************************************************"
echo "Run the startOpenFOAM+ script to launch container"
echo "**************************************************"

