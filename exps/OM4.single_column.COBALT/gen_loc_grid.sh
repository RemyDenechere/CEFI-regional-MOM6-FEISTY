######################################################################
#	Generate grid files for several test location in the
#		Californie Current Ecosystem
######################################################################
# Default location: 
./BuildExchangeGrid.sh BATS 31.6667 -64.1667 4000
./BuildExchangeGrid.sh CCE  33.7756 -118.9783 100

# CCE locations: 
#./BuildExchangeGrid.sh CCE_loc1  34.2781 -120.6810 30
#./BuildExchangeGrid.sh CCE_loc2  34.2023 -119.7996 126
#./BuildExchangeGrid.sh CCE_loc3  33.7756 -118,9783 100
#./BuildExchangeGrid.sh CCE_loc4  33.4322 -118.0712 445
#./BuildExchangeGrid.sh CCE_loc5  32.7071 -117.3941 385
#./BuildExchangeGrid.sh CCE_loc6  33.4249 -119.7737 83
#./BuildExchangeGrid.sh CCE_loc7  32.9129 -118.0203 23
#./BuildExchangeGrid.sh CCE_loc8  32.8385 -119,0199 81
#./BuildExchangeGrid.sh CCE_loc9  32.0355290 -118.5381390 100
#./BuildExchangeGrid.sh CCE_loc10  31.9889637 -117.5351529 65
#./BuildExchangeGrid.sh CCE_loc11 32.9161201 -120.2922059 49

# Copy FEISTY input files in locs:
for ((i=1; i<=11; i++))
do
	cp CCE/FEISTY_2023_10_spinup_subset.nc CCE_loc${i}
	echo " Copy FEISTY input file in CCE_loc${i}"
done
