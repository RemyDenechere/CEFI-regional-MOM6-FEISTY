#!/bin/bash

# List of locations
locations=(BATS CCE GBK GMX OSP) # BATS GBK GMX GMX_2

# Experiment name
if [ -z "$1" ]; then
    exp="FEISTY--non-vertical-globalIC"
else
    exp=$1
fi

value_Rfug=$(echo "10^-10" | bc -l)
echo "Rfug value:" $value_Rfug

# Loop through each location and run the script
for loc in "${locations[@]}"; do
    echo "Running ./parallel_loop.sh " $loc " 1 5 0 0.4 1 70 70 1 1 1 5 $value_Rfug 1 " $exp
    ./parallel_loop.sh $loc 20 6 0 0.5 1 70 70 1 1 1 5 $value_Rfug 1 $exp
done

echo "All locations processed successfully."
