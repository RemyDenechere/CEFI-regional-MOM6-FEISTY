#!/bin/bash

# List of locations
locations=(BATS) # BATS CCE GOM NS GMX

# Experiment name
if [ -z "$1" ]; then
<<<<<<< HEAD
    exp="FEISTY--non-vertical-16Jun25"
=======
    exp="FEISTY--non-vertical-new-fast"
>>>>>>> f0756d0458bbf90508f7d7afc05b848dae2b67eb
else
    exp=$1
fi

value_Rfug=$(echo "10^-10" | bc -l)
echo "Rfug value:" $value_Rfug

# Loop through each location and run the script
for loc in "${locations[@]}"; do
    echo "Running ./parallel_loop.sh " $loc " 1 5 0 0.4 1 70 70 1 1 1 5 $value_Rfug 1 " $exp
<<<<<<< HEAD
    ./parallel_loop.sh $loc 7 6 0 0.5 6 50 90 1 1 1 1 $value_Rfug $value_Rfug $exp 
=======
    ./parallel_loop.sh $loc 1 1 0.1 0.1 1 70 70 1 1 1 1 $value_Rfug $value_Rfug $exp 
>>>>>>> f0756d0458bbf90508f7d7afc05b848dae2b67eb
done

echo "All locations processed successfully."
