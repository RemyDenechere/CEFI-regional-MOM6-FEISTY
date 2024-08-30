#!/bin/bash
#
# FILE REMOVER / CLEANUP
#
#
echo "Removing netCDF files..."
rm *.nc
#
#
echo "Removing stats files..."
rm -f stdout*.*
rm profile*
rm available_diags*
rm *.stats
rm *_doc.*
rm *.out 

read -p "Do you want to clear RESTART folder? (y/n): " answer

# CONVERT THE ANSWER TO LOWERCASE
answer=${answer,,}  # This makes the input lowercase (y/n)

# CHECK THE USER'S RESPONSE
if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
    echo "You chose yes, clearing RESTART folder...."
    rm -rf RESTART/*
elif [[ "$answer" == "n" || "$answer" == "no" ]]; then
    echo "Not clearing out RESTART folder."
    # Add your logic here for "no" response
else
    echo "Invalid response, assuming NO!"
fi