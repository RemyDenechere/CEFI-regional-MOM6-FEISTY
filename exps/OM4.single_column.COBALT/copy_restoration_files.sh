cp ../datasets/restoring_files/salt_restore_woa13_decav_BATS.nc BATS
cp ../datasets/restoring_files/salt_restore_woa13_decav_GBK.nc GBK
cp ../datasets/restoring_files/salt_restore_woa13_decav_GMX.nc GMX
cp ../datasets/restoring_files/salt_restore_woa13_decav_GMX_2.nc GMX_2
mv BATS/salt_restore_woa13_decav_BATS.nc BATS/salt_restore_woa13_decav.nc
mv GBK/salt_restore_woa13_decav_GBK.nc GBK/salt_restore_woa13_decav.nc
mv GMX/salt_restore_woa13_decav_GMX.nc GMX/salt_restore_woa13_decav.nc
mv GMX_2/salt_restore_woa13_decav_GMX_2.nc GMX_2/salt_restore_woa13_decav.nc
cp ../datasets/restoring_files/temp_restore_woa13_decav_BATS.nc BATS
cp ../datasets/restoring_files/temp_restore_woa13_decav_GBK.nc GBK
cp ../datasets/restoring_files/temp_restore_woa13_decav_GMX.nc GMX
cp ../datasets/restoring_files/temp_restore_woa13_decav_GMX_2.nc GMX_2
mv BATS/temp_restore_woa13_decav_BATS.nc BATS/temp_restore_woa13_decav.nc
mv GBK/temp_restore_woa13_decav_GBK.nc GBK/temp_restore_woa13_decav.nc
mv GMX/temp_restore_woa13_decav_GMX.nc GMX/temp_restore_woa13_decav.nc
mv GMX_2/temp_restore_woa13_decav_GMX_2.nc GMX_2/temp_restore_woa13_decav.nc

echo "Restoration files copied to respective directories."



