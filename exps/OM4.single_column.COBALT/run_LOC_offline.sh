#!/bin/bash

# List of locations
locations=(GMX) # BATS GOM CCE NS GMX

# Loop through each location and run the script
for loc in "${locations[@]}"; do
    echo "Running ./run_COBALT_offline.sh for location: $loc"
    ./run_COBALT_offline.sh "$loc"
done

echo "All locations processed successfully."
