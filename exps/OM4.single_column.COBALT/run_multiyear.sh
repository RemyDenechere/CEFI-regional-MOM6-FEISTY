#!/bin/bash
#
# THIS SCRIPT ALLOWS TO LOOP THE 1D COLUNM RUN OF THE ONLINE 
# COBALT-FEISTY OVER A GIVEN NUMBER OF ITERATIONS <NUM_ITERATIONS>
# 
# CONTACT: REMY DENECHERE <RDENECHERE@UCSD.EDU>
#        : JARED BRZENSKI <JABRZENSKI@UCSD.EDU>
#
# usage: ./run_COBALT_FEISTY_loop.sh BATS 10 test
#        ./run_COBALT_FEISTY_loop.sh CCE 20 baseparam
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
#
# CHECK IF THE CORRECT NUMBER OF ARGUMENTS ARE PROVIDED
MPI_COMMAND="mpiexec --cpu-set # --bind-to core --report-bindings -np 1"

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <Unique Name> <number of iterations (years)> < reference number > <cpu_core>"
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
UNIQUE_NAME="$1"
NUM_ITERATIONS="$2"
NONFMORT="$3"
CPU_CORE="$4"

# SET HOME DIRECTORY
HOME_DIR=$(pwd)

# This variable will be set by a overlord
UNIQUE_ID=10

# SETUP FOLDER FOR PARALLES RUNS
LONG_NAME="nonFmort_${NONFMORT}"
WORK_DIR="${SCRATCH_DIR}/${LONG_NAME}"
if [ -d "$WORK_DIR" ]; then
    echo "$WORK_DIR" exists 
else 
    cd "${SCRATCH_DIR}"
    mkdir "${LONG_NAME}"
    cd "${HOME_DIR}"
fi


if [ -d "$WORK_DIR" ]; then
	echo "${WORK_DIR} exists, continuing..."
else
	echo "${WORKDIR} does not exist, exiting..."
	exit 1
fi

# COPY EVERYTHING TO THE SCRATCH DIRECTORY
cp -rf * "${WORK_DIR}"

# MOVE TO WROKING DIRECTORY
cd "${WORK_DIR}"

# MAKE THE RUNS DIRECTORY
mkdir RUNS

# EDIT THE INPUT FILE FOR nonFmort
NEW_LINE="nonFmort = ${NONFMORT}"
sed -i "/nonFmort/c\\ ${NEW_LINE}" input.nml


####################################################
## Do we need to resetup this over and over?
####################################################
# Seems like if one works, they will all work ??
# ## SET UP THE INPUT FILE FOR THE EXPERIMENT: 
# #cd ../exps/OM4.single_column.COBALT/
# rm -rf INPUT/*
# cd INPUT/ && ../../../link_database.sh && cd ..
# #yes | cp -i "$build_name"/* INPUT/



####################################################
#  RUN THE MODEL 
####################################################
cp "${CEFI_EXECUTABLE_LOC}" . 

mpiexec --cpu-set "${CPU_CORE}" --bind-to core --report-bindings -np 1 ./MOM6SIS2 |& tee stdout."${UNIQUE_ID}".env
#mpirun -np 1 ./MOM6SIS2 |& tee stdout."${UNIQUE_ID}".env

####################################################
# MOVE THE DATA TO A NEW FOLDER: 
####################################################
FOLDER_SAVE_LOC="RUNS/${UNIQUE_NAME}"

if [ -d "$FOLDER_SAVE_LOC" ]; then
    echo "$FOLDER_SAVE_LOC" exist 
else 
    mkdir "$FOLDER_SAVE_LOC"
fi

# SAVE YEAR 1!!
YEAR_FOLDER_PATH="$FOLDER_SAVE_LOC/${UNIQUE_NAME}_nonFmort${NONFMORT}_yr_1"
if [ -d "$YEAR_FOLDER_PATH" ]; then 
    rm -rf "$YEAR_FOLDER_PATH"/*
else 
    mkdir "$YEAR_FOLDER_PATH"
fi

yes | cp -i *feisty*.nc "$YEAR_FOLDER_PATH"

# Loop after 1st year: -----------------------------------------------------------------------------
## Set up restart in input.nml file and get restart files: 
sed -i "s/input_filename = 'n'/input_filename = 'r'/g" input.nml
yes | cp -i RESTART/*.nc INPUT/

for ((i=2; i<=NUM_ITERATIONS; i++))
do
    # Create a new folder to save the data of that year: 
    YEAR_FOLDER_PATH="$FOLDER_SAVE_LOC/${UNIQUE_NAME}_nonFmort${NONFMORT}_yr_${i}"
    if [ -d "$YEAR_FOLDER_PATH" ]; then 
        rm -rf "$YEAR_FOLDER_PATH"/*
    else 
        mkdir "$YEAR_FOLDER_PATH"/
    fi

    # Run the model and save the outputs in $folder_save_exp
    mpiexec --cpu-set "${CPU_CORE}" --bind-to core --report-bindings -np 1  ./MOM6SIS2 |& tee stdout."${UNIQUE_ID}".env
    #mpirun -np 1 ./MOM6SIS2 |& tee stdout."${UNIQUE_ID}".env
    yes | cp -i *feisty*.nc "$YEAR_FOLDER_PATH"/

    # get restart files: 
    yes | cp -i RESTART/*.nc INPUT/
done

# End the experiment: -----------------------------------------------------------------------------
## save the restart files of last year for potential resimulation: 
FOLDER_SAVE_RESTART="${UNIQUE_NAME}_restart_nonFmort${NONFMORT}_yr_${NUM_ITERATIONS}"

mkdir "$FOLDER_SAVE_RESTART"

yes | cp -i RESTART/*.nc "$FOLDER_SAVE_RESTART"/

## set up back to the original configuration
sed -i "s/input_filename = 'r'/input_filename = 'n'/g" input.nml


############################################
# SAVE EVERYTHING IN THE SAVE DIRECTORY
############################################
cp -r RUNS/* "$SAVE_DIR"
cp -r "$FOLDER_SAVE_RESTART" "${SAVE_DIR}/${UNIQUE_NAME}"

cd "$HOME_DIR"
rm -r "$WORK_DIR"

echo "Simulation done!"
