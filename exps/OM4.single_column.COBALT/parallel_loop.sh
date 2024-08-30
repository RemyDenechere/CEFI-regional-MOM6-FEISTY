#!/bin/bash
#
# THIS SCRIPT ALLOWS PARALLEL 
# LOOP THE 1D COLUNM RUN OF THE ONLINE 
# COBALT-FEISTY OVER A GIVEN NUMBER OF ITERATIONS <NUM_ITERATIONS>
# 
# CONTACT: JARED BRZENSKI <JABRZENSKI@UCSD.EDU>
#
# usage: ./parallel_loop  <NumParallelLoops> <UniqueName> <numberofiterations (years)> <reference_number>
#
# RUN THIS SCRIPT FROM THE CEFI/EXPS/OM4 DIRECTORY
#
# REQUIRES ENVIRONMENT VARIABLES:
#
# CEFI_DATASET_LOC     -> the location of the dataset, which link_databse needs
# CEFI_EXECUTABLE_LOC  -> the location of MOM6SIS2 you want to run
# SCRATCH_DIR          -> location you want to work from, must exist!!!
# SAVE_DIR             -> location of the final saved files. 
#
# YOU CAN ALSO SET THEM HERE, UNCOMMENT THE FOUR FOLLOWING LINES AND SET:
export CEFI_DATASET_LOC=/project/rdenechere/CEFI-regional-MOM6-FEISTY/exps
# export CEFI_EXECUTABLE_LOC=
# export SCRATCH_DIR= 
# export SAVE_DIR=
#
########################################################################################

# CHECK IF THE CORRECT NUMBER OF ARGUMENTS ARE PROVIDED
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <numofloops> <Unique Name> <number of iterations (years)> < reference number >"
    exit 1
fi

# CHECK TO SEE IF OTHER ENVIRONMENTAL VARIABLES ARE SET
if [ -z "${CEFI_DATASET_LOC}" ]; then
    echo "CEFI_DATASET_LOC is not set, exiting"
    exit 1
elif [ -z "${CEFI_EXECUTABLE_LOC}" ]; then
    echo "CEFI_EXECUTABLE_LOC not set, exiting"
    exit 1
elif [ -z "${SCRATCH_DIR}" ]; then
    echo "SCRATCH_DIR not set, exiting."
    exit 1
elif [ -z "${SAVE_DIR}" ]; then
    echo "SAVE_DIR not set, exiting"
    exit 1
else
    echo "Found all environmental variables, continuing..."
fi

# ASSIGN ARGUMENTS TO VARIABLES
NUM_LOOPS="$1"
UNIQUE_NAME="$2"
NUM_ITERATIONS="$3"
EXP_REF="$4"

# CHECK TO MAKE SURE NUM LOOPS IS A NUMBER, >= 1
if [[ "$NUM_LOOPS" =~ ^[0-9]+$ ]] && (( NUM_LOOPS >= 1 )); then
    echo "Running run_multiyear $NUM_LOOPS times..."
else
    echo "$NUM_LOOPS is not a valid number or is less than 1, quitting..."
    exit 1
fi

for i in $(seq 1 $NUM_LOOPS); do
    #./test.sh "$i" &
    #echo "${EXP_REF}.$i"
    ./run_multiyear.sh "${UNIQUE_NAME}" "${NUM_ITERATIONS}" "${EXP_REF}.$i" &
done
