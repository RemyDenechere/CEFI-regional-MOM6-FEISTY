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
# usage: ./parallel_loop <LocationName> <number of years> <number of discretizations> <nonFmort Starting Value> <nonFmort Ending Value> <experimentation name>
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
# YOU CAN ALSO SET THEM HERE, UNCOMMENT THE FOUR FOLLOWING LINES AND SET:
export CEFI_DATASET_LOC=/project/rdenechere/CEFI-regional-MOM6-FEISTY/exps/datasets/
export CEFI_EXECUTABLE_LOC=/project/rdenechere/CEFI-regional-MOM6-FEISTY/builds/build/rockfish-linux-gnu/ocean_ice/debug/MOM6SIS2
export SCRATCH_DIR=/scratch
export SAVE_DIR=/project/rdenechere/COBALT_output/parallel/
#
########################################################################################
# FUNCTIONS USED BY SCRIPT
#
# FUNTION TO GENERATE ARRAY OF NUMBERS BETWEEN, AND INCLUSIVE, OF TWO NUMEBRS GIVEN
generate_array() {
    local start=$1
    local end=$2
    local num_elements=$3

    # Round tot his many significant digits, changeable
    local round_to_this_digit=3

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

#FUNCTION TO KILL ALL SPAWNED PROCESSES
cleanup() {
  echo "Terminating all spawned processes..."
  echo "Cehck the SCRATCH directory for any stray files."
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

########################################################################################
# CHECK IF THE CORRECT NUMBER OF ARGUMENTS ARE PROVIDED
if [ "$#" -ne 15 ]; then
    echo "Usage: $0 <LocationName> <number of years> 
    <number of fmort discretizations> <nonFmort Starting Value> <nonFmort Ending Value>
    <Number of encounter_coefficient discretizations> <encouter_coef start value> <encounter_coef end value>
    <K discretizations> <K start value> <K end value><K50 discretizations> <K50 start value> <K50 end value> 
    <Experimentation Name>"
    echo "If any discretizations number == 1, only the starting value is used in the range."
    echo "If K is equal to 1, this is type 2 function."
    echo "If K is >= 1, this is a type 3 function."
    echo ""
    echo ""
    exit 1
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

# ASSIGN ARGUMENTS TO VARIABLES
LOCATION_NAME="$1"
NUM_YEARS="$2"
FMORT_DISC="$3"
FMORT_START="$4"
FMORT_END="$5"
ENCOUNTER_DISC="$6"
ENCOUNTER_START="$7"
ENCOUNTER_END="$8"
K_DISC="$9"
K_START="${10}"
K_END="${11}"
K50_DISC="${12}"
K50_START="${13}"
K50_END="${14}"
EXP_NAME="${15}"

###############################################################################
# CHECK TO MAKE SURE FMORT_DISC, THE NUMBER OF PARALLEL LOOPS TO
# RUN,  IS A NUMBER, >= 1
if [[ "$FMORT_DISC" =~ ^[0-9]+$ ]] && (( FMORT_DISC >= 1 )); then
    echo "Running run_multiyear.sh $FMORT_DISC times..."
else
    echo "$FMORT_DISC is not a valid number or is less than 1, quitting..."
    exit 1
fi

###############################################################################
# CHECK IF THE FMORT ARGUMENT IS A NUMBER BETWEEN 0 AND 1 (INCLUSIVE)
echo "Checking nonFmort start and end values..."
if (( $FMORT_DISC > 1 )); then
    if [[ "$FMORT_START" =~ ^0(\.[0-9]+)?$|^1(\.0+)?$ ]]; then
        echo "Fmort start value $FMORT_START is between 0 and 1 (inclusive)"
    else
        echo "FMort start value $FMORT_START is not between 0 and 1 (inclusive), exiting..."
        exit 1
    fi

    if [[ "$FMORT_END" =~ ^0(\.[0-9]+)?$|^1(\.0+)?$ ]]; then
        echo "Fmort end value $FMORT_END is between 0 and 1 (inclusive)"
    else
        echo "FMort end value $FMORT_END is not between 0 and 1 (inclusive), exiting..."
        exit 1
    fi
fi
echo ""

###############################################################################
# CHECK IF THE ENCOUNTER ARGUMENT IS A NUMBER BETWEEN 0 AND 1 (INCLUSIVE)
echo "Checking encounter start and end values..."
    if (( $ENCOUNTER_DISC > 1  )); then
    if (( "$ENCOUNTER_START" >= 30 && "$ENCOUNTER_START" <= 110 )) ; then
        echo "Encounter start value $ENCOUNTER_START is between 30 and 110 (inclusive)"
    else
        echo "Encounter start value $ENCOUNTER_START is not between 30 and 110 (inclusive), exiting..."
        exit 1
    fi

    if (( "$ENCOUNTER_END" > "$ENCOUNTER_START" && "$ENCOUNTER_END" <= 110 )); then
        echo "Encounter end value $ENCOUNTER_END is between $ENCOUNTER_START  and 110 (inclusive)"
    else
        echo "Encounter end value $ENCOUNTER_END is not between $ENCOUNTER_START and 110 (inclusive), exiting..."
        exit 1
    fi
fi
echo ""

###############################################################################
# CHECK IF THE K Exponent ARGUMENT IS A NUMBER BETWEEN 1 AND 10 (INCLUSIVE)
if (( "$K_DISC" > 1 )); then
    echo "Checking K start and end values..."
    #if (( "$K_START" >= 1 && "$K_START" <= 20 )); then
    if (( $(echo "$K_START >= 1.0" | bc -l) )); then
        echo "K start value $K_START is >= 1 (inclusive)"
    else
        echo "K start value $K_START is not between 1 and 20 (inclusive), exiting..."
        exit 1
    fi

    if (( $(echo "$K_END > $K_START" | bc -l) )); then
        echo "K end value $K_END is between $K_START  and 10 (inclusive)"
    else
        echo "K end value $K_END is not between $K_START and 10 (inclusive), exiting..."
        exit 1
    fi
else
    echo "K value of 1 used. Function type 2"
fi
echo ""

###############################################################################
# CHECK IF THE K50 Exponent ARGUMENT IS A NUMBER BETWEEN 1 AND 20 (INCLUSIVE)
if (( "$K50_DISC" > 1 )); then
    echo "Checking K50 start and end values..."
    if (( $(echo "$K50_START >= 1.0" | bc -l) )); then
        echo "K50 start value $K50_START is >= 1 (inclusive)"
    else
        echo "K50 start value $K50_START is not between 1 and 20 (inclusive), exiting..."
        exit 1
    fi

    if (( $(echo "$K50_END > $K50_START" | bc -l) )); then
        echo "K50 end value $K50_END is between $K50_START  and 20 (inclusive)"
    else
        echo "K50 end value $K50_END is not between $K50_START and 20 (inclusive), exiting..."
        exit 1
    fi
else
    echo "K50, strange things happened? Check BASh logic please."
fi
echo ""
###############################################################################
###############################################################################
# GENERATE THE ARRAY OF VALUES TO TRY FOR FMORT
# Generate array
if (( $FMORT_DISC > 1 )); then
    NONFMORT_ARRAY=($(generate_array $FMORT_START $FMORT_END $FMORT_DISC))
    # find last index
    last_index=$((${#NONFMORT_ARRAY[@]} - 1))
    # Ensure the first and last values are the two desired values
    NONFMORT_ARRAY[0]="$FMORT_START"
    NONFMORT_ARRAY[$last_index]=$FMORT_END
else 
    NONFMORT_ARRAY[0]="$FMORT_START"
fi

echo "nonFmort will use the following values: ${NONFMORT_ARRAY[@]}"
echo ""

###############################################################################
# GENERATE THE ARRAY OF VALUES TO TRY FOR ENCOUNTER
# Generate array
if (( $ENCOUNTER_DISC > 1 )); then
    ENCOUNTER_ARRAY=($(generate_array $ENCOUNTER_START $ENCOUNTER_END $ENCOUNTER_DISC))
    # find last index
    last_index=$((${#ENCOUNTER_ARRAY[@]} - 1))
    # Ensure the first and last values are the two desired values
    ENCOUNTER_ARRAY[0]="$ENCOUNTER_START"
    ENCOUNTER_ARRAY[$last_index]=$ENCOUNTER_END
else 
    ENCOUNTER_ARRAY[0]="$ENCOUNTER_START"
fi

echo "Encounter will use the following values: ${ENCOUNTER_ARRAY[@]}"
echo ""

###############################################################################
# GENERATE THE ARRAY OF VALUES TO TRY FOR K
# Generate array
if (( $K_DISC > 1 )); then 
    K_ARRAY=($(generate_array $K_START $K_END $K_DISC))
    # find last index
    last_index=$((${#K_ARRAY[@]} - 1))
    # Ensure the first and last values are the two desired values
    K_ARRAY[0]="$K_START"
    K_ARRAY[$last_index]=$K_END
else
    K_ARRAY[0]=$K_START
fi
echo "K will use the following values: ${K_ARRAY[@]}"
echo ""
echo "###############################################################################"

###############################################################################
# GENERATE THE ARRAY OF VALUES TO TRY FOR K50
# Generate array
if (( $K50_DISC > 1 )); then 
    K50_ARRAY=($(generate_array $K50_START $K50_END $K50_DISC))
    # find last index
    last_index=$((${#K50_ARRAY[@]} - 1))
    # Ensure the first and last values are the two desired values
    K50_ARRAY[0]="$K50_START"
    K50_ARRAY[$last_index]=$K50_END
else
    K50_ARRAY[0]=$K50_START
fi

echo "K50 will use the following values: ${K50_ARRAY[@]}"
echo ""
echo "###############################################################################"

###############################################################################
# SETUP nonFmort VARIABLE TO UNIQUE VALUE EACH LOOP
# CURRENTLY IT WILL STEP BY VALUES OF 0.01
CPU_CORE=1
for i in $(seq 1 $FMORT_DISC); do
    
    for j in $(seq 1 $ENCOUNTER_DISC); do

        for k in $(seq 1 $K_DISC); do

            for m in $(seq 1 $K50_DISC); do

                # ADJUST FOR STARTING AND ENDING VALUES.
                #NONFMORT_VAL=$(bc -l <<< "scale=2; $EXP_REF+(${i}-1)/100")
                NONFMORT_VAL="${NONFMORT_ARRAY[$i-1]}"
                ENCOUNTER_VAL="${ENCOUNTER_ARRAY[$j-1]}"
                K_VAL="${K_ARRAY[$k-1]}"
                K50_VAL="${K50_ARRAY[$m-1]}"

                # echo "The value generated by loop ${i} is ${NONFMORT_VAL}"

                # RUN ON SPECIFIC CPU CORE. START AT 10
                echo "This will run on CPU_CORE ${CPU_CORE}"

                # ACTUAL COMMAND TO RUN THE MULTIYEAR BASH SCRIPT.
                # & SYBMOL AT THE END MEANS IT WILL NOT WAIT FOR THE PROGRAM TO FINISH BEFORE 
                # CONTINUING THROUGH THIS LOOP
                if [ $LOCATION_NAME == "TEST" ]; then
                    echo "TEST -- Running./run_multiyear.sh ${LOCATION_NAME} ${NUM_YEARS} ${CPU_CORE} ${NONFMORT_VAL} ${ENCOUNTER_VAL} ${K_VAL} ${K50_VAL} ${EXP_NAME}" 
            	echo ""
                else
                    ./run_multiyear.sh "${LOCATION_NAME}" "${NUM_YEARS}" "${CPU_CORE}" "${NONFMORT_VAL}"  "${ENCOUNTER_VAL}" "${K_VAL}" "${K50_VAL}" "${EXP_NAME}"&
                fi
                # Store PID for the cleanup trap function
                pids+=($!)

                CPU_CORE=$((CPU_CORE + 1 ))
                
                if (( $CPU_CORE > 127 )); then
                    echo "!!"
                    echo "Too many cores used...exiting."
                    echo "!!"
                    exit 1
                fi
            done
        done
    done
done

# WAIT FOR ALL OF THE COMMANDS TO COMPLETE, THIS OVERRULES THE & SYMBOL
wait

echo "All ${NUM_LOOPS} simulations finished!"

