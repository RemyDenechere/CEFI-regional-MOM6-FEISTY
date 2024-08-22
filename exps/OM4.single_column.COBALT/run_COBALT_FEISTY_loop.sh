#!/bin/bash
#
# This script allows to loop the 1D colunm run of the online COBALT-FEISTY over a given number of years <nbr_year_to_run>
# contact: remy denechere <rdenechere@ucsd.edu>
# usage: ./run_COBALT_FEISTY_loop.sh BATS 10 test
#        ./run_COBALT_FEISTY_loop.sh CCE 20 baseparam


# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <station_name> <nbr_year_to_run> <experimentation_ref>"
    exit 1
fi

# Assign arguments to variables
station_name="$1"
nbr_year_to_run="$2"
experimentation_ref="$3"

# Test if the folder containing the grid files is in the directory: 
if [ -d "$station_name" ]; then
    echo  "run simulation at "$station_name" for "$nbr_year_to_run" years for the following experiment: " $experimentation_ref 
else
    echo "Folder "$station_name" does not exist in the current directory. Check <station_name>"
    exit 1
fi

# 1st year: -----------------------------------------------------------------------------
## Build the model: 
cd ../../builds
./linux-build.bash -m redhat580 -p linux-gnu -t prod -f mom6sis2

## set up the input file for the experiment: 
cd ../exps/OM4.single_column.COBALT/
rm -rf INPUT/*
cd INPUT/ && ../../../gen_link.sh && cd ..
yes | cp -i "$station_name"/* INPUT/

## Run the model 
PATH=$PATH:/usr/lib64/openmpi/bin/
PATH=$PATH:/usr/local/src/ncview-2.1.7/
source ../../builds/redhat580/linux-gnu.env 
../../builds/build/redhat580-linux-gnu/ocean_ice/prod/MOM6SIS2 |& tee stdout.redhat

## move the data to a new folder: 
folder_save_loc="../../../rdenechere/COBALT_output/COBALT_FEISTY/${station_name}"
if [ -d "$folder_save_loc" ]; then
    echo "$folder_save_loc" exist 
else 
    mkdir "$folder_save_loc"
fi
folder_save_exp="$folder_save_loc/${station_name}_${experimentation_ref}_yr_1"
if [ -d "$folder_save_exp" ]; then 
    rm -rf "$folder_save_exp"/*
else 
    mkdir "$folder_save_exp"
fi

yes | cp -i *feisty*.nc "$folder_save_exp"

# Loop after 1st year: -----------------------------------------------------------------------------
## Set up restart in input.nml file and get restart files: 
sed -i "s/input_filename = 'n'/input_filename = 'r'/g" input.nml
yes | cp -i RESTART/*.nc INPUT/

for ((i=2; i<=nbr_year_to_run; i++))
do
    # Create a new folder to save the data of that year: 
    folder_save_exp="$folder_save_loc/${station_name}_${experimentation_ref}_yr_${i}"
    if [ -d "$folder_save_exp" ]; then 
        rm -rf "$folder_save_exp"/*
    else 
        mkdir "$folder_save_exp"/
    fi

    # Run the model and save the outputs in $folder_save_exp
    ../../builds/build/redhat580-linux-gnu/ocean_ice/prod/MOM6SIS2 |& tee stdout.redhat
    yes | cp -i *feisty*.nc "$folder_save_exp"/

    # get restart files: 
    yes | cp -i RESTART/*.nc INPUT/
done


# End the experiment: -----------------------------------------------------------------------------
## save the restart files of last year for potential resimulation: 
# folder_save_restart = "${station_name}_exps_restart/${station_name}_${experimentation_ref}_yr_${nbr_year_to_run}/"
# yes | cp -i RESTART/*.nc "$folder_save_restart"/

## set up back to the original configuration
sed -i "s/input_filename = 'r'/input_filename = 'n'/g" input.nml

echo "Simulation done!"