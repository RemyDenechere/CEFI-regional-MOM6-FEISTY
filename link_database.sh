#!/bin/bash

# Check if dataset variable is set in environment
#
# sample: if datasets is located at /usr/mnt/drive/datasets
#
# run command
# > export CEFI_DATASET_LOC=/usr/mnt/drive/datasets

if [ -z "${CEFI_DATASET_LOC}" ]; then
    echo "CEFI_DATASET_LOC is not set."
else
    echo "CEFI_DATASET_LOC is set to '${CEFI_DATASET_LOC}'."

    ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/atm_delta_13C_14C.nc ./atm_delta_13C_14C.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/atmos_mosaic.nc ./atmos_mosaic.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/atmos_mosaic_tile1Xocean_mosaic_tile1.nc ./atmos_mosaic_tile1Xocean_mosaic_tile1.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/bgc_woa_esper_ics_1993_2023-04_BATS.nc ./bgc_woa_esper_ics_1993_2023-04_BATS.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/cfc.bc.nc ./cfc.bc.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/COBALT_2023_10_spinup_2003_subset.nc ./COBALT_2023_10_spinup_2003_subset.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/depflux_total.mean.1860.nc ./depflux_total.mean.1860.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/diag_rho2.nc ./diag_rho2.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/geothermal_davies2013_v1.nc ./geothermal_davies2013_v1.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/GLODAPv1.abiotic.filled.20180316.nc ./GLODAPv1.abiotic.filled.20180316.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/GLODAPv2.2016b.oi-filled.20180322.nc ./GLODAPv2.2016b.oi-filled.20180322.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/grid_spec.nc ./grid_spec.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/init_ocean_cobalt_nh3.res.nc ./init_ocean_cobalt_nh3.res.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/init_ocean_cobalt.res.nc ./init_ocean_cobalt.res.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/huss_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-4-0_gr_200401010000-200412312100.padded.nc ./JRA_huss.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/prra_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-4-0_gr_200401010130-200412312230.padded.nc ./JRA_prra.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/prsn_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-4-0_gr_200401010130-200412312230.padded.nc ./JRA_prsn.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/psl_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-4-0_gr_200401010000-200412312100.padded.nc ./JRA_psl.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/rlds_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-4-0_gr_200401010130-200412312230.padded.nc ./JRA_rlds.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/rsds_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-4-0_gr_200401010130-200412312230.padded.nc ./JRA_rsds.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/tas_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-4-0_gr_200401010000-200412312100.padded.nc ./JRA_tas.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/uas_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-4-0_gr_200401010000-200412312100.padded.nc ./JRA_uas.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/vas_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-4-0_gr_200401010000-200412312100.padded.nc ./JRA_vas.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/land_mask.nc ./land_mask.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/land_mosaic.nc ./land_mosaic.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/land_mosaic_tile1Xocean_mosaic_tile1.nc ./land_mosaic_tile1Xocean_mosaic_tile1.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/Mineral_Fe_Flux_PI.nc ./Mineral_Fe_Flux_PI.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/MOM_GENERICS.res.nc ./MOM_GENERICS.res.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/MOM_IC.nc ./MOM_IC.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/mosaic.nc ./mosaic.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/news_nutrients.nc ./news_nutrients.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/ocean_hgrid.nc ./ocean_hgrid.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/ocean_mask.nc ./ocean_mask.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/ocean_mosaic.nc ./ocean_mosaic.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/ocean_topog.nc ./ocean_topog.nc
	ln -fs ocean_topog.nc ./topog.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/river_iron.nc ./river_iron.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/seawifs-clim-1997-2010.1440x1080.v20180328.nc ./seawifs-clim-1997-2010.1440x1080.v20180328.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/Soluble_Fe_Flux_PI.nc ./Soluble_Fe_Flux_PI.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/woa13_all_i_annual_01.nc ./woa13_all_i_annual_01.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/woa13_all_n_annual_01.nc ./woa13_all_n_annual_01.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/woa13_all_o_annual_01.nc ./woa13_all_o_annual_01.nc
	ln -fs ${CEFI_DATASET_LOC}/OceanBGC_dataset/woa13_all_p_annual_01.nc ./woa13_all_p_annual_01.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/woa13_decav_ptemp_monthly_fulldepth_01.nc ./woa13_decav_ptemp_monthly_fulldepth_01.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/woa13_decav_s_monthly_fulldepth_01.nc ./woa13_decav_s_monthly_fulldepth_01.nc
	ln -fs ${CEFI_DATASET_LOC}/OM4_025.JRA.single_column/woa13_decav_s_monthly_fulldepth_01.nc ./woa13_decav_s_monthly_fulldepth_01.nc
	# ln -fs ${CEFI_DATASET_LOC}/FEISTY_2023_10_spinup_subset.nc ./FEISTY_2023_10_spinup_subset.nc
fi


