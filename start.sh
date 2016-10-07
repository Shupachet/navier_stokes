#!/bin/bash
# this script will
#   i) Start  OpenFOAM+ container with name 'of_v1606_plus'
#  in the  the shell-terminal. 
#  User also need to run xhost+ from other terminal
#  Note: Docker daemon should be running before launching script 
#  PostProcessing: User can launch paraview/paraFoam from terminal
#  to postprocess the results
#  Note: user can launch script in different  shell to have OpenFOAM 
#  working environment in different terminal
xhost +local:of_v1606_plus
docker start  of_v1606_plus
docker exec -it of_v1606_plus /bin/bash -rcfile /opt/OpenFOAM/setImage_v1606+

