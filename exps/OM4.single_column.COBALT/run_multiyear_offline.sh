#!/bin/bash
#
# THIS SCRIPT ALLOWS TO LOOP THE 1D COLUNM RUN OF THE OFFLINE 
# COBALT-FEISTY FOR A GIVEN LOCATION
# 
# CONTACT: REMY DENECHERE <RDENECHERE@UCSD.EDU>
#        : JARED BRZENSKI <JABRZENSKI@UCSD.EDU>
#
# usage: ./run_multiyear_offline.sh 
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
# Example MPI command to run this without this script:
# MPI_COMMAND="mpiexec --cpu-set # --bind-to core --report-bindings -np 1"
#
###############################################################################
#
#FUNCTION TO KILL ALL SPAWNED PROCESSES
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

# CHECK IF THE CORRECT NUMBER OF ARGUMENTS ARE PROVIDED
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <Location name> <number of year> <cpu_core>"
    exit 1
fi

# ASSIGN ARGUMENTS TO VARIABLES
LOC=$1
NUM_YEARS=$2
CPU_CORE=$3

###############################################################################
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

###############################################################################
# SET HOME DIRECTORY
HOME_DIR=$(pwd)

# This variable will be set by a overlord
UNIQUE_ID=10

# SETUP FOLDER FOR PARALLES RUNS
LONG_NAME="offline/${LOC}"
WORK_DIR="${SCRATCH_DIR}/${LONG_NAME}"
if [ -d "$WORK_DIR" ]; then
    echo "$WORK_DIR" exists 
else 
    cd "${SCRATCH_DIR}"
    if [ -d "offline" ]; then
        echo "offline directory exists"
    else
        echo "offline directory does not exist, making it..."
        mkdir offline
    fi
    cd offline
    mkdir "${LOC}"
    cd "${HOME_DIR}"
fi

if [ -d "$WORK_DIR" ]; then
	echo "${WORK_DIR} exists, continuing..."
else
	echo "${WORKDIR} does not exist, exiting..."
	exit 1
fi

###############################################################################
# COPY EVERYTHING TO THE SCRATCH DIRECTORY
# clean work dir
rm -rf "${WORK_DIR}"/*
cp -rf * "${WORK_DIR}"

# MOVE TO WORKING DIRECTORY
cd "${WORK_DIR}"

# MAKE THE RUNS DIRECTORY

if [ -d "${WORK_DIR}/RUNS" ]; then
    echo "RUNS Directory exists."
else
    echo "RUNS Directory does not exist, making it..."
    mkdir RUNS
fi

# NO NEED TO EDIT THE INPUT FILE
cd INPUT/
/project/rdenechere/CEFI-regional-MOM6-FEISTY/link_database.sh "${LOC}"
cd ..

# Check if the line do_FEISTY = .false. in input.nml
if sed -n '/^\s*do_FEISTY\s*=\s*\.true\.\s*$/p' input.nml > /dev/null; then
  echo "Found 'do_FEISTY = .true.' in input.nlm: COBALT is setup to run online with FEISTY"
  echo "Changing to 'do_FEISTY = .false.' to run COBALT offline."

  # Change online to offline setup:  
  sed -i 's/^\(\s*do_FEISTY\s*=\s*\)\.true\.\(\s*\)$/\1.false.\2/' input.nml
  
  echo "Change complete."
elif sed -n '/^\s*do_FEISTY\s*=\s*\.false\.\s*$/p' input.nml > /dev/null; then
    echo "COBALT is setup to run offline. Continuing..."
else 
  echo "do_FEISTY value not found or invalid."
  echo exit 1 
fi

#########################################################
#  CHECK IF MODEL IS IN RESTART OR INITIALIZATION MODE 
#########################################################
# sed -i "s/input_filename = 'n'/input_filename = 'r'/g" input.nml
# Check if the line contains input_filename = 'r' in input.nml
if grep -q "input_filename = 'r'" input.nml; then
    echo "Found 'input_filename = 'r'' in input.nml. Changing it to 'n'."
    sed -i "s/input_filename = 'r'/input_filename = 'n'/g" input.nml
    echo "Change complete."
else
    if grep -q "input_filename = 'n'" input.nml; then
         echo "'input_filename = 'n'' continuing..."
    else 
        echo "input_filename value not found or invalid."
        echo "Exiting..."
        exit 1
    fi
fi



####################################################
#  RUN THE MODEL FOR YEAR 1 
####################################################
echo "Copying executable from ${CEFI_EXECUTABLE_LOC} to here"
cp "${CEFI_EXECUTABLE_LOC}" . 

mpiexec --cpu-set "${CPU_CORE}" --bind-to core --report-bindings -np 1 ./MOM6SIS2 |& tee stdout."${UNIQUE_ID}".env&
pids+=($1)
wait 

####################################################
# MOVE THE DATA TO A FOLDER IN RUN DIRECTORY: 
####################################################

FOLDER_SAVE_LOC="RUNS/${LOC}"
if [ -d "$FOLDER_SAVE_LOC" ]; then
    echo "$FOLDER_SAVE_LOC" exist 
else 
    mkdir "${FOLDER_SAVE_LOC}"
fi

YEAR_FOLDER_PATH="$FOLDER_SAVE_LOC/${LOC}_offline_yr_1"
if [ -d "$YEAR_FOLDER_PATH" ]; then
    echo "$YEAR_FOLDER_PATH" exist 
    rm -rf "$YEAR_FOLDER_PATH"/*
else 
    mkdir "$YEAR_FOLDER_PATH"
fi

echo "Saving feisty files to specific YEAR_FOLDER_PATH"
yes | cp -i *feisty*.nc "$YEAR_FOLDER_PATH"


####################################################
# Loop after 1st year: -----------------------------------
## Set up restart in input.nml file and move restart files into the INPUT folder: 
sed -i "s/input_filename = 'n'/input_filename = 'r'/g" input.nml
yes | cp -i RESTART/*.nc INPUT/

# LOOP THROUGH THE NUMBER OF YEARS
for ((i=2; i<=NUM_YEARS; i++))
do
    echo ""
    echo "--------------------------------------"
    echo "Running year ${i} of ${NUM_YEARS}..."
    
    # RUN THE MODEL
    mpiexec --cpu-set "${CPU_CORE}" --bind-to core --report-bindings -np 1 ./MOM6SIS2 |& tee stdout."${UNIQUE_ID}".env&
    pids+=($1)
    wait 

    # MOVE THE DATA TO A NEW FOLDER: 
    YEAR_FOLDER_PATH="$FOLDER_SAVE_LOC/${LOC}_offline_yr_${i}"
    if [ -d "$YEAR_FOLDER_PATH" ]; then 
        rm -rf "$YEAR_FOLDER_PATH"/*
    else 
        mkdir "$YEAR_FOLDER_PATH"
    fi

    echo "Saving feisty files to specific YEAR_FOLDER_PATH"
    yes | cp -i *feisty*.nc "$YEAR_FOLDER_PATH"
done

###############################################################################
# End the experiment: ---------------------------------------------------------
## save the restart files of last year for potential resimulation: 
FOLDER_SAVE_RESTART="${LOC}_yr_${NUM_YEARS}_OFFLINE_RESTART"
if [ -d "$FOLDER_SAVE_RESTART" ]; then
    echo "$FOLDER_SAVE_RESTART" exist 
    rm -rf "$FOLDER_SAVE_RESTART"/*
else 
    mkdir "$FOLDER_SAVE_RESTART"
fi

echo
echo "Saving RESTART files into FOLDER_SAVE_RESTART"
yes | cp -i RESTART/*.nc "$FOLDER_SAVE_RESTART"/

############################################
# SAVE EVERYTHING IN THE SAVE DIRECTORY
############################################
echo "Copying RUNS folder to SAVE_DIR"
yes | cp -r RUNS/* "$SAVE_DIR"
echo "Copying RESTART to SAVE_DIR"
yes | cp -r "$FOLDER_SAVE_RESTART" "${SAVE_DIR}/${LOC}"

cd "$HOME_DIR"
# REMOVE WORKING DIRECTORY AND FOLDERS, ETC...
# rm -r "$WORK_DIR"

echo "Simulation done!"

## Set up restart in input.nml file and move restart files into the INPUT folder: 
sed -i "s/input_filename = 'r'/input_filename = 'n'/g" input.nml

