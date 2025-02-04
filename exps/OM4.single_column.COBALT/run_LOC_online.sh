#!/bin/bash

# List of locations
locations=(BATS CCE GOF NS) # 

# Experiment name
if [ -z "$1" ]; then
    exp="FEISTY--non-vertical"
else
    exp=$1
fi

# Loop through each location and run the script
for loc in "${locations[@]}"; do
    echo "Running ./parallel_loop.sh " $loc " 10 1 0.1 0.1 1 70 70 1 1 1 1 1 1 " $exp
    ./parallel_loop.sh $loc 10 1 0.1 0.1 1 70 70 1 1 1 1 1 1 $exp 
done

echo "All locations processed successfully."