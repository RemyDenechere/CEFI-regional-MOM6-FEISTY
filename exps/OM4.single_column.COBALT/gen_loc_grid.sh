######################################################################
#	Generate grid files for several test location in the
#		Californie Current Ecosystem
######################################################################
# Default locations: 
./BuildExchangeGrid.sh BATS 31.6667 -64.1667 4000 # Bermuda Atlantic Time Series
./BuildExchangeGrid.sh CCE 34.2781 -120.6810 30 # California Current Ecosystem
./BuildExchangeGrid.sh GOM 43.2874 -70.5328 75	# Gold Of Main 
./BuildExchangeGrid.sh GMX 28.8503 -89.714 200	# Gold Of Mexico 
./BuildExchangeGrid.sh NS  53.7217 3.2790   50  # Noth Sea

# Generate initial conditions for the the various locations: 
## BATS: 
ncea -d lath,30,34 -d lonh,-66,-62 -d latq,30,34 -d lonq,-66,-62 ../datasets/nwa12_datasets/nwa12_input/NWA12_COBALT_2023_10_spinup_2003.nc BATS/COBALT_2023_10_spinup_2003_subset.nc
ncatted -O -a _FillValue,,o,f,1.00000002004088e+20 BATS/COBALT_2023_10_spinup_2003_subset.nc
echo "COBALT_2023_10_spinup_2003_subset.nc created for BATS"

## GOM: 
ncea -d lath,32,36 -d lonh,-122,-118 -d latq,32,36 -d lonq,-122,-118 ../datasets/nwa12_datasets/nwa12_input/NWA12_COBALT_2023_10_spinup_2003.nc GOM/COBALT_2023_10_spinup_2003_subset.nc
ncatted -O -a _FillValue,,o,f,1.00000002004088e+20 GOM/COBALT_2023_10_spinup_2003_subset.nc
echo "COBALT_2023_10_spinup_2003_subset.nc created for GOM"

# GMX: 
ncea -d lath,27,31 -d lonh,-92,-88 -d latq,27,31 -d lonq,-92,-88  ../datasets/nwa12_datasets/nwa12_input/NWA12_COBALT_2023_10_spinup_2003.nc GMX/COBALT_2023_10_spinup_2003_subset.nc
ncatted -O -a _FillValue,,o,f,1.00000002004088e+20 GMX/COBALT_2023_10_spinup_2003_subset.nc
echo "COBALT_2023_10_spinup_2003_subset.nc created for GMX"

## CCE:
# ./datasets/nwa12_datasets/nwa12_input/NWA12_COBALT_2023_10_spinup_2003.nc
## NS:



# # CCE locations to test : 
# ./BuildExchangeGrid.sh CCE_loc1  34.2781 -120.6810 30
# ./BuildExchangeGrid.sh CCE_loc2  34.2023 -119.7996 126
# ./BuildExchangeGrid.sh CCE_loc3  33.7756 -118,9783 100
# ./BuildExchangeGrid.sh CCE_loc4  33.4322 -118.0712 445
# ./BuildExchangeGrid.sh CCE_loc5  32.7071 -117.3941 385
# ./BuildExchangeGrid.sh CCE_loc6  33.4249 -119.7737 83
# ./BuildExchangeGrid.sh CCE_loc7  32.9129 -118.0203 23
# ./BuildExchangeGrid.sh CCE_loc8  32.8385 -119,0199 81
# ./BuildExchangeGrid.sh CCE_loc9  32.0355290 -118.5381390 100
# ./BuildExchangeGrid.sh CCE_loc10  31.9889637 -117.5351529 65
# ./BuildExchangeGrid.sh CCE_loc11 32.9161201 -120.2922059 49

# # Copy FEISTY CCE input files in locs:
# for ((i=1; i<=11; i++))
# do
# 	cp CCE/FEISTY_2023_10_spinup_subset.nc CCE_loc${i}
# 	echo " Copy FEISTY input file in CCE_loc${i}"
# done



