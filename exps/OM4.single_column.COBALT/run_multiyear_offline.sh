#!/bin/bash
#
# THIS SCRIPT ALLOWS TO LOOP THE 1D COLUNM RUN OF THE OFFLINE 
# COBALT-FEISTY FOR A GIVEN LOCATION
# 
# CONTACT: REMY DENECHERE <RDENECHERE@UCSD.EDU>
#        : JARED BRZENSKI <JABRZENSKI@UCSD.EDU>
#
# usage: ./run_multiyear_offline.sh BATS 10 test core#
#        ./run_multiyear_offline.sh CCE 20 baseparam core#
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
# CHECK IF THE CORRECT NUMBER OF ARGUMENTS ARE PROVIDED

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <Unique Name> <Location ID> <cpu_core>"
    exit 1
fi

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
# ASSIGN ARGUMENTS TO VARIABLES
UNIQUE_NAME="$1"
LOC_ID="$2"
CPU_CORE="$3"
#/project/rdenechere/COBALT_output/COBALT_offline_forcing_files/CCE

###############################################################################
# SET HOME DIRECTORY
HOME_DIR=$(pwd)

# This variable will be set by a overlord
UNIQUE_ID=10

# SETUP FOLDER FOR PARALLES RUNS
LONG_NAME="${UNIQUE_NAME}_loc${LOC_ID}"
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

###############################################################################
# COPY EVERYTHING TO THE SCRATCH DIRECTORY
cp -rf * "${WORK_DIR}"

# MOVE TO WROKING DIRECTORY
cd "${WORK_DIR}"

# MAKE THE RUNS DIRECTORY
mkdir RUNS

# NO NEED TO EDIT THE INPUT FILE
cd INPUT/
/project/rdenechere/CEFI-regional-MOM6-FEISTY/link_database.sh "${LONG_NAME}"
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


####################################################
#  RUN THE MODEL 
####################################################
cp "${CEFI_EXECUTABLE_LOC}" . 

mpiexec --cpu-set "${CPU_CORE}" --bind-to core --report-bindings -np 1 ./MOM6SIS2 |& tee stdout."${UNIQUE_ID}".env
#mpirun -np 1 ./MOM6SIS2 |& tee stdout."${UNIQUE_ID}".env

####################################################
# MOVE THE DATA TO A NEW FOLDER: 
####################################################
FOLDER_SAVE_LOC="${SAVE_DIR}/${LONG_NAME}"

if [ -d "$FOLDER_SAVE_LOC" ]; then
    echo "$FOLDER_SAVE_LOC" exist 
else 
    mkdir "$FOLDER_SAVE_LOC"
fi

yes | cp -i *feisty*.nc "$FOLDER_SAVE_LOC"


############################################
# SAVE EVERYTHING IN THE SAVE DIRECTORY
############################################
cp -r RUNS/* "$SAVE_DIR"
cp -r "$FOLDER_SAVE_RESTART" "${SAVE_DIR}/${UNIQUE_NAME}"

cd "$HOME_DIR"
# REMOVE WORKING DIRECTORY AND FOLDERS, ETC...
rm -r "$WORK_DIR"

echo "Simulation done!"

#####################################################
#   ALTERNATIVE FOR CHEAKING do_FEISTY WITH AWK
#####################################################
# #!/bin/bash
# FILE="input.nml"

# # Function to return FEISTY value using awk
# get_feisty_value() {
# awk -F "=" '/do_FEISTY/ {
#     # Trim spaces and periods around the value after the equal sign
#     gsub(/^[. \t]+|[. \t]+$/, "", $2);
#     print $2;
#     }' "$FILE"
# }

# # Call the function and store the result
# FEISTY_VALUE=$(get_feisty_value)

# echo do_FEISTY value is: $FEISTY_VALUE

# # Check the result and perform actions
# if [[ "$FEISTY_VALUE" == "true" ]]; then
#     echo "FEISTY is true. Performing Action 1."
#     echo
# elif [[ "$FEISTY_VALUE" == "false" ]]; then
#     echo "FEISTY is false. Performing Action 2."
#     echo
# else
#     echo "FEISTY value not found or invalid."
#     echo
# fi