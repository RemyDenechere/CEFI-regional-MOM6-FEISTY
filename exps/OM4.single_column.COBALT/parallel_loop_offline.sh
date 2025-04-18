#!/bin/bash
########################################################################################
# Parallel FEISTY Multiyear run script
########################################################################################
# THIS SCRIPT ALLOWS PARALLEL LOOP THE 1D COLUNM RUN OF THE ONLINE 
# COBALT-FEISTY OVER A GIVEN NUMBER OF ITERATIONS <NUM_ITERATIONS>
# 
# CONTACT: JARED BRZENSKI <JABRZENSKI@UCSD.EDU>
#          REMY DENECHERE <RDENECHERE@UCSD.EDU>
#
# ROCKFISH:
# MOM6SIS2 must be built on rockfish using the "rockfish" build folder
# folder under builds, with the included mk and env files. It needs mpifort and mpicc as
# the compilers, as well as the appropriate environment modules loaded.
# 
# This is a parallel driver for run_multiyear.sh, which can be run independant of this script.
# 
#
# usage: ./parallel_loop <LocationName> <number of years> <number of discretizations> <nonFmort Starting Value> <nonFmort Ending Value>
# 
# INPUTS:
#       LocationName: Location of simulation, should match environmental variable for sanity.
#                     If equal to "TEST", only echo results, no simulations are done
#
#       Number of Years: Number of years a single simulation will run. Input for run_multiyear.sh
#
#       Number of Discratizations: Number of unique values between X_START_VALUE and X_END_VALUE inclusively,
#                                  where X_START_VALUE is the starting value for parameter X, and X_END_VALUE
#                                  is the ending value for parameter X.
#
#       nonFmort Starting Value: Starting parameter value for nonFmort.
#
#       nonFmort Ending Value: Eding parameter value for nonFmort.
#
#
# RUN THIS SCRIPT FROM THE CEFI/EXPS/OM4 DIRECTORY
#
#
# REQUIRES ENVIRONMENT VARIABLES:
#
# CEFI_DATASET_LOC     -> the location of the dataset, which link_databse needs
# CEFI_EXECUTABLE_LOC  -> the location of MOM6SIS2 you want to run
# SCRATCH_DIR          -> location you want to work from, must exist!!!
# SAVE_DIR             -> location of the final saved files.This will be created
#
########################################################################################
# FUNCTIONS USED BY SCRIPT
cleanup() {
  echo "Terminating all spawned processes..."
  echo "Check the SCRATCH directory for any stray files."
  echo "Killing processes DOES NOT clean up the file system."
  for pid in "${pids[@]}"; do
    kill "$pid" 2>/dev/null
  done
  exit 0
}

# EMPTY ARRAY 
pids=()

# Trap Ctrl-C (SIGINT) and call cleanup function
trap cleanup SIGINT 


echo ""
echo ""
echo "###############################################################################"
echo "# Starting parallel run of single column MOM6                                 #"
echo "###############################################################################"
echo ""

# CHECK IF THE CORRECT NUMBER OF ARGUMENTS ARE PROVIDED
if [[ "$#" -gt 3 ||  "$#" -lt 2 ]]; then
    echo "Usage: $0 <number of years> <Experimentation name> <Rockfish: true/false>"
    echo "Usage: $0 <20> <2D> <Rockfish: default value false>"
    exit 1

elif [ "$#" -eq 2 ]; then
    NUM_YEARS=$1
    EXP=$2	
    ROCKFISH="false"
    echo "runing offline for $with default rockfish value false"

elif [ "$#" -eq 3 ]; then
    # VALIDATE THE BOOLEAN ARGUMENT
    if [ "$2" != "true" ] && [ "$2" != "false" ]; then
        echo "Error: The second argument must be 'true' or 'false'."
        exit 1
    fi
    NUM_YEARS=$1
    EXP=$2	
    ROCKFISH=$3
fi

# DEFINE COUNTER 
j=0


########################################################################################
# YOU CAN ALSO SET THEM HERE, UNCOMMENT THE FOUR FOLLOWING LINES AND SET:
export CEFI_DATASET_LOC=/project/rdenechere/CEFI-regional-MOM6-FEISTY/exps/datasets/
export SCRATCH_DIR=/scratch
export SAVE_DIR=/project/rdenechere/COBALT_output/COBALT_offline_forcing_files/
if [ "$ROCKFISH" = "false" ]; then
    export CEFI_EXECUTABLE_LOC=/project/rdenechere/CEFI-regional-MOM6-FEISTY/builds/build/monkfish-linux-gnu/ocean_ice/prod/MOM6SIS2
else 
    export CEFI_EXECUTABLE_LOC=/project/rdenechere/CEFI-regional-MOM6-FEISTY/builds/build/rockkfish-linux-gnu/ocean_ice/prod/MOM6SIS2
fi


# DEFINE THE LOCATION TO RUN:
locations=(BATS) #  BATS GOM GMX CCE NS


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
 
# PRINT PRESETED DIRECTORIES
echo "Set directories : "
echo "CEFI_DATASET_LOC: $CEFI_DATASET_LOC"
echo "CEFI_EXECUTABLE_LOC: $CEFI_EXECUTABLE_LOC"
echo "SAVE_DIR: $SAVE_DIR"


###############################################################################
# LOOP THROUGH EACH LOCATION
for loc in "${locations[@]}"; do
    # INCREMENT THE LOOP COUNTER
    j=$((j+1))

    # RUN ON SPECIFIC CPU CORE. START AT 11
    CPU_CORE=$((j+10))
    echo ""
    echo "###############################################################################"
    echo "This will run location ${loc} on CPU_CORE ${CPU_CORE}"  

    # ACTUAL COMMAND TO RUN THE MULTIYEAR OFFLINE BASH SCRIPT.
    # & SYBMOL AT THE END MEANS IT WILL NOT WAIT FOR THE PROGRAM TO FINISH BEFORE 
    # CONTINUING THROUGH THIS LOOP
    ./run_multiyear_offline.sh "${loc}" "${NUM_YEARS}" "${CPU_CORE}" "${EXP}"&
    # Store PID for the cleanup trap function
    pids+=($!)
done

# WAIT FOR ALL OF THE COMMANDS TO COMPLETE, THIS OVERRULES THE & SYMBOL
wait

echo "All offline simulations of COBALT finished for ${NUM_YEARS} spinup year!"