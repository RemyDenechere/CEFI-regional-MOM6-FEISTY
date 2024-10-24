#!/bin/bash
########################################################################################
# Parallel FEISTY Multiyear run script
########################################################################################
# THIS SCRIPT ALLOWS PARALLEL LOOP THE 1D COLUNM RUN OF THE ONLINE 
# COBALT-FEISTY OVER A GIVEN NUMBER OF ITERATIONS <NUM_ITERATIONS>
# 
# CONTACT: JARED BRZENSKI <JABRZENSKI@UCSD.EDU>
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
#
# FUNTION TO GENERATE ARRAY OF NUMBERS BETWEEN, AND INCLUSIVE, OF TWO NUMEBRS GIVEN
generate_array() {
    local start=$1
    local end=$2
    local num_elements=$2

    # Round tot his many significant digits, changeable
    local round_to_this_digit=0

    # Calculate the increment (step size)
    local increment=$(echo "scale=$round_to_this_digit; ($end - $start) / ($num_elements - 1)" | bc)

    local result=()

    # Populate the array
    for (( i=0; i<num_elements; i++ )); do
        value=$(echo "scale=$round_to_this_digit; $start + $i * $increment" | bc)
        result+=($value)
    done

    # Print the array, basically returns the array as output, which is saved to a variable.
    echo "${result[@]}"
}

# FUNCTION FOR CHECKING IF INPUT IS A NUMBER (DECIMAL)
isnum_Case() { case ${1#[-+]} in ''|.|*[!0-9.]*|*.*.*) return 1;; esac ;}

########################################################################################

# CHECK IF THE CORRECT NUMBER OF ARGUMENTS ARE PROVIDED
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <LocationName> <Location Starting Value> <number of Locations>"
    exit 1
fi

# ASSIGN ARGUMENTS TO VARIABLES
LOCATION_NAME="$1"
LOC_START="$2"
NUM_PARALLEL_DISC="$3"

# YOU CAN ALSO SET THEM HERE, UNCOMMENT THE FOUR FOLLOWING LINES AND SET:
export CEFI_DATASET_LOC=/project/rdenechere/CEFI-regional-MOM6-FEISTY/exps/datasets/
export CEFI_EXECUTABLE_LOC=/project/rdenechere/CEFI-regional-MOM6-FEISTY/builds/build/rockfish-linux-gnu/ocean_ice/prod/MOM6SIS2
export SCRATCH_DIR=/scratch/
if [ $LOCATION_NAME == "TEST" ]; then
    export SAVE_DIR=/project/rdenechere/COBALT_output/COBALT_offline_forcing_files/CCE
else
    export SAVE_DIR=/project/rdenechere/COBALT_output/COBALT_offline_forcing_files/"${LOCATION_NAME}"
fi


echo "###############################################################################"
echo "# Starting parallel run of single column MOM6                                 #"
echo "###############################################################################"
echo ""

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
# CHECK TO MAKE SURE NUM_PARALLEL_DISC, THE NUMBER OF PARALLEL LOOPS TO
# RUN,  IS A NUMBER, >= 1
if [[ "$NUM_PARALLEL_DISC" =~ ^[0-9]+$ ]] && (( NUM_PARALLEL_DISC >= 1 )); then
    echo "Running run_multiyear_offlines.sh $NUM_PARALLEL_DISC times..."
else
    echo "$NUM_PARALLEL_DISC is not a valid number or is less than 1, quitting..."
    exit 1
fi

###############################################################################
# GENERATE THE ARRAY OF VALUES TO TRY FOR PARAMETER
# Generate array
LOC_ARRAY=($(generate_array $LOC_START $NUM_PARALLEL_DISC $NUM_PARALLEL_DISC))
# find last index
last_index=$((${#LOC_ARRAY[@]} - 1))
# Ensure the first and last values are the two desired values
# NONFMORT_ARRAY[0]="$FMORT_START"
# NONFMORT_ARRAY[$last_index]=$FMORT_END

echo "Location will use the following values: ${LOC_ARRAY[@]}"
echo ""
echo "###############################################################################"

###############################################################################
# SETUP nonFmort VARIABLE TO UNIQUE VALUE EACH LOOP
# CURRENTLY IT WILL STEP BY VALUES OF 0.01
for i in $(seq 1 $NUM_PARALLEL_DISC); do

    # ADJUST FOR STARTING AND ENDING VALUES.
    #NONFMORT_VAL=$(bc -l <<< "scale=2; $EXP_REF+(${i}-1)/100")
    LOC_VAL="${LOC_ARRAY[$i-1]}"

    # RUN ON SPECIFIC CPU CORE. START AT 10
    CPU_CORE=$((i+10))
    echo "This will run location ${LOC_VAL} on CPU_CORE ${CPU_CORE}"  


    # ACTUAL COMMAND TO RUN THE MULTIYEAR BASH SCRIPT.
    # & SYBMOL AT THE END MEANS IT WILL NOT WAIT FOR THE PROGRAM TO FINISH BEFORE 
    # CONTINUING THROUGH THIS LOOP
    if [ $LOCATION_NAME == "TEST" ]; then
        echo "TEST -- Running./run_multiyear_offline.sh ${LOCATION_NAME} ${LOC_VAL} ${CPU_CORE}"
	echo ""
    else
        ./run_multiyear_offline.sh "${LOCATION_NAME}" "${LOC_VAL}" "${CPU_CORE}"&
    fi
    
done

# WAIT FOR ALL OF THE COMMANDS TO COMPLETE, THIS OVERRULES THE & SYMBOL
wait

echo "All ${NUM_LOOPS} simulations finished!"