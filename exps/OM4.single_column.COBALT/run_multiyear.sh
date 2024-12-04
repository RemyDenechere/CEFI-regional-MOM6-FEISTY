#!/bin/bash
#
# THIS SCRIPT ALLOWS TO LOOP THE 1D COLUNM RUN OF THE ONLINE 
# COBALT-FEISTY OVER A GIVEN NUMBER OF YEARS <NUM_YEARS>
# WITH A SPECIFIC PARAMETER VALUE FOR NONFMORT.
# 
# CONTACT: REMY DENECHERE <RDENECHERE@UCSD.EDU>
#        : JARED BRZENSKI <JABRZENSKI@UCSD.EDU>
#
# usage: ./run_COBALT_FEISTY_loop.sh BATS 10 test core#
#        ./run_COBALT_FEISTY_loop.sh CCE 20 baseparam core#
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
# NONFMORT_DEFAULT=0.3
# ENCOUNTER_DEFAULT=70
# K_EXP_DEFAULT=1
# K50_EXP_DEFAULT=1


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


DEFAULT_VALUES=false



# CHECK IF THE CORRECT NUMBER OF ARGUMENTS ARE PROVIDED
if [ "$#" -eq 2 ]; then
    DEFAULT_VALUES=true
    echo "Using default values for:"
    echo "Fmort"
    echo "Encounter"
    echo "K"
    echo "K50"
    echo ""
fi


if [ "$#" -ne 8 ] && [ "$#" -ne 2 ]; then
    echo "Usage: $0 <Location Name> <number of (years)> <cpu_core> "
    echo "<nonFmort Value> <encounter_val> <k value> <k50 value> <Experimentation Name>"
    echo ""
    echo "nonFmort: fish mortality"
    echo "encounter val: coefficient of encounters [ 30 - 110 ]"
    echo "k value: exponent, k==1 function of 2nd type, k>1, function of thrid type"
    echo "k50 value: exponent, 1 < k50 < 20"
    echo "Experimentation Name: subfolder to save data"
    echo ""
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

if [ "$DEFAULT_VALUES" = true ]; then
    LOC_NAME="$1"
    NUM_YEARS="$2"
    CPU_CORE=$((1 + $RANDOM % 20))
    EXP_NAME="DEFAULT_VALUE"
else
    LOC_NAME="$1"
    NUM_YEARS="$2"
    CPU_CORE="$3"
    NONFMORT="$4"
    ENCOUNTER="$5"
    K_EXP="$6"
    K50_EXP="$7"
    EXP_NAME="$8"
fi

###############################################################################
# SET HOME DIRECTORY
HOME_DIR=$(pwd)

# This variable will be set by a overlord
UNIQUE_ID="${LOC_NAME}_CPU_${CPU_CORE}_nonFmort_${NONFMORT}_encounter_${ENCOUNTER}_k_${K_EXP}"

# SETUP FOLDER FOR PARALLES RUNS
if [ "$DEFAULT_VALUES" = true ]; then
    UNIQUE_ID="${LOC_NAME}_CPU_${CPU_CORE}_nonFmort_DEFAULT_encounter_DEFAULT_k_DEFAULT_k50_DEFAULT"
    LONG_NAME="${LOC_NAME}_nonFmort_DEFAULT_encounter_DEFAULT_k_DEFAULT_k50_DEFAUlt"
else
    LONG_NAME="${LOC_NAME}_nonFmort_${NONFMORT}_encounter_${ENCOUNTER}_k_${K_EXP}_k50_${K50_EXP}"
    UNIQUE_ID="${LOC_NAME}_CPU_${CPU_CORE}_nonFmort_${NONFMORT}_encounter_${ENCOUNTER}_k_${K_EXP}_k50_${K50_EXP}"
fi

WORK_DIR="${SCRATCH_DIR}/${EXP_NAME}/${LONG_NAME}"
EXP_DIR="${SCRATCH_DIR}/${EXP_NAME}/"
if [ -d "$WORK_DIR" ]; then
    echo "$WORK_DIR" exists 
else 
    echo "$WORK_DIR" does not exist
    cd "${SCRATCH_DIR}"
    if [ -d "$EXP_NAME" ]; then
        echo "$EXP_NAME" exists create "$LONG_NAME"
        mkdir "${LONG_NAME}"
    else
        echo create "$EXP_NAME" and "$LONG_NAME"
        mkdir "${EXP_NAME}"
        cd    "${EXP_NAME}"
        mkdir "${LONG_NAME}"
    fi 
    cd "${HOME_DIR}"
fi


if [ -d "$WORK_DIR" ]; then
	echo "${WORK_DIR} exists, continuing..."
else
	echo "${WORK_DIR} does not exist, exiting..."
	exit 1
fi

###############################################################################
# COPY EVERYTHING TO THE SCRATCH DIRECTORY
echo "Copying EVERYTHING! to the WORK_DIR"
cp -rf * "${WORK_DIR}"

# MOVE TO WROKING DIRECTORY
cd "${WORK_DIR}"

# MAKE THE RUNS DIRECTORY
if [ -d "${WORK_DIR}/RUNS" ]; then
    echo "RUNS Directory exists."
else
    echo "RUNS Directory does not exist, making it..."
    mkdir RUNS
fi
#mkdir RUNS

if [ "$#" -eq 7 ]; then
    # EDIT THE INPUT FILE FOR nonFmort
    NEW_LINE="nonFmort = ${NONFMORT}"
    sed -i "/nonFmort/c\\ ${NEW_LINE}" input.nml

    # EDIT THE INPUT FILE FOR encounter
    NEW_LINE="a_enc = ${ENCOUNTER}"
    sed -i "/a_enc/c\\ ${NEW_LINE}" input.nml

    # EDIT THE INPUT FILE FOR K
    NEW_LINE="k_fct_tp = ${K_EXP}"
    sed -i "/k_fct_tp/c\\ ${NEW_LINE}" input.nml

    # EDIT THE INPUT FILE FOR K50
    NEW_LINE="k50 = ${K50_EXP}"
    sed -i "/k50/c\\ ${NEW_LINE}" input.nml
fi


cd INPUT/
/project/rdenechere/CEFI-regional-MOM6-FEISTY/link_database.sh "${LOC_NAME}"
cd ..


####################################################
#  RUN THE MODEL 
####################################################
echo "Copying executable from ${CEFI_EXECUTABLE_LOC} to here"
cp "${CEFI_EXECUTABLE_LOC}" . 

mpiexec --cpu-set "${CPU_CORE}" --bind-to core --report-bindings -np 1 ./MOM6SIS2 |& tee stdout."${UNIQUE_ID}".env&
pids+=($1)
wait

#mpirun -np 1 ./MOM6SIS2 |& tee stdout."${UNIQUE_ID}".env

####################################################
# MOVE THE DATA TO A NEW FOLDER: 
####################################################
FOLDER_SAVE_LOC="RUNS/${LOC_NAME}/${EXP_NAME}"

if [ -d "$FOLDER_SAVE_LOC" ]; then
    echo "$FOLDER_SAVE_LOC" exist 
else 
    echo "$FOLDER_SAVE_LOC" does not exist
    cd RUNS 
    if [ -d "$LOC_NAME" ]; then # test subfolder EXP_NAME
        echo  create "$EXP_NAME"
        cd "${LOC_NAME}"     
        mkdir "${EXP_NAME}"
    else 
        echo  create  "$LOC_NAME" and "$EXP_NAME"
        mkdir "${LOC_NAME}"
        cd "${LOC_NAME}"
        mkdir "${EXP_NAME}"
    fi 
fi
cd "${WORK_DIR}"

# SAVE YEAR 1!!
YEAR_FOLDER_PATH="$FOLDER_SAVE_LOC/${LONG_NAME}_yr_1"
if [ -d "$YEAR_FOLDER_PATH" ]; then 
    rm -rf "$YEAR_FOLDER_PATH"/*
else 
    mkdir "$YEAR_FOLDER_PATH"
fi

echo "Saving feisty files to specific YEAR_FOLDER_PATH"
yes | cp -i *feisty*.nc "$YEAR_FOLDER_PATH"

###############################################################################
# Loop after 1st year: --------------------------------------------------------
## Set up restart in input.nml file and get restart files: 
sed -i "s/input_filename = 'n'/input_filename = 'r'/g" input.nml
yes | cp -i RESTART/*.nc INPUT/

for ((i=2; i<=NUM_YEARS; i++))
do
    # Create a new folder to save the data of that year: 
    YEAR_FOLDER_PATH="$FOLDER_SAVE_LOC/${LONG_NAME}_yr_${i}"
    if [ -d "$YEAR_FOLDER_PATH" ]; then 
        rm -rf "$YEAR_FOLDER_PATH"/*
    else 
        mkdir "$YEAR_FOLDER_PATH"/
    fi

    # Run the model and save the outputs in $folder_save_exp
    mpiexec --cpu-set "${CPU_CORE}" --bind-to core --report-bindings -np 1  ./MOM6SIS2 |& tee stdout."${UNIQUE_ID}".env&
    # 
    pids+=($!)
    wait

    echo "Copying feisty files to YEAR_FOLDER_PATH"
    yes | cp -i *feisty*.nc "$YEAR_FOLDER_PATH"/

    # get restart files: 
    echo "Copying RESTART files back to INPUT, there is some clobbering!"
    yes | cp -i RESTART/*.nc INPUT/
done

###############################################################################
# End the experiment: ---------------------------------------------------------
## save the restart files of last year for potential resimulation: 
FOLDER_SAVE_RESTART="${LONG_NAME}_yr_${NUM_YEARS}_RESTART"

mkdir "$FOLDER_SAVE_RESTART"

echo
echo "Saving RESTART files into FOLDER_SAVE_RESTART"
yes | cp -i RESTART/*.nc "$FOLDER_SAVE_RESTART"/

## set up back to the original configuration
sed -i "s/input_filename = 'r'/input_filename = 'n'/g" input.nml


############################################
# SAVE EVERYTHING IN THE SAVE DIRECTORY
############################################
echo "Copying RUNS folder to SAVE_DIR"
yes | cp -r RUNS/* "$SAVE_DIR"
echo "Copying RESTART to SAVE_DIR"
yes | cp -r "$FOLDER_SAVE_RESTART" "${SAVE_DIR}/${LOC_NAME}"

cd "$HOME_DIR"
# REMOVE WORKING DIRECTORY AND FOLDERS, ETC...
# rm -fr "$EXP_DIR"/

echo "Simulation done!"
