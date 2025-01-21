#!/bin/bash
#
# This script the COBALT simulation without FEISTY: 
# contact: remy denechere <rdenechere@ucsd.edu>
# usage: ./run_COBALT_offline.sh BATS 
#        ./run_COBALT_offline.sh CCE 

# ---------------------------------------------------------------------------------------
# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <station_name>"
    exit 1
fi

# ---------------------------------------------------------------------------------------
# Assign arguments to variables
station_name="$1"

# ---------------------------------------------------------------------------------------
# Test if the folder containing the grid files is in the directory: 
if [ -d "$station_name" ]; then
    echo "run Offline COBALT simulation at " $station_name
else
    echo "Folder "$station_name" does not exist in the current directory. Check <station_name>"
    exit 1
fi

# ---------------------------------------------------------------------------------------
# Test if the folder to save outputs: 
folder_save="../../../COBALT_output/COBALT_offline_forcing_files/${station_name}/"
if [ -d "$folder_save" ]; then
    echo "$folder_save" exist 
else 
    mkdir "$folder_save"
fi

# export path for openmpi and ncview (potentially load module instead)
#export PATH=$PATH:/usr/lib64/openmpi/bin/
#export PATH=$PATH:/usr/local/src/ncview-2.1.7/

# ---------------------------------------------------------------------------------------
## Turn off FEISTY: 
sed -i "s/do_FEISTY                  = .true./do_FEISTY                  = .false./g" input.nml

# ---------------------------------------------------------------------------------------
## set up the input file for the experiment: (make this with symbolic links)
dir_run
rm -rf INPUT/*
cd INPUT/ && ../../../link_database.sh "$station_name" && cd ..
# yes | cp -i "$station_name"/* INPUT/

# ---------------------------------------------------------------------------------------
## Run the model 
source ../../builds/redhat580/linux-gnu.env 
../../builds/build/redhat580-linux-gnu/ocean_ice/prod/MOM6SIS2 |& tee stdout.redhat.offline

## move the data to a new folder: 
yes | cp -i *feisty*.nc "$folder_save"

## set up back to the original configuration
sed -i "s/do_FEISTY                  = .false./do_FEISTY                  = .true./g" input.nml

echo "Simulation done!"
