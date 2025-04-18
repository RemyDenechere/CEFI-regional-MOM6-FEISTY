#!/bin/bash
# module nco/5.1.6-ok5oedt or cdo/2.2.2-rgmyuut 

# set -x 

# Define file paths
SOURCE_FILE_4D="20040101.ocean_cobalt_restart.nc"
MODIFIED_SOURCE_FILE_4D="modified_ocean_cobalt_restart.nc"
SOURCE_FILE_3D="20040101.ocean_cobalt_btm.nc"
MODIFIED_SOURCE_FILE_3D="modified_ocean_cobalt_btm.nc"
TARGET_FILE="COBALT_2023_10_spinup_2003_subset.nc"


# CHECK IF THE CORRECT NUMBER OF ARGUMENTS ARE PROVIDED
if [ "$#" -ne 1 ]; then
    echo "Wrong number of arguments provided. exiting ... "
    echo "Usage: $0 <LOC>"
    exit 1
fi

# ALLOCATE INPUT
LOC=$1

# Get input file from loc 
yes | cp -i ${LOC}/COBALT_2023_10_spinup_2003_subset.nc .

# Rename dimensions in the source file
yes | cp "$SOURCE_FILE_4D" "$MODIFIED_SOURCE_FILE_4D"
ncrename -d xh,lonh -d yh,lath -d zl,Layer -d time,Time "$MODIFIED_SOURCE_FILE_4D"
ncrename -d xh,lonh -d yh,lath -d time,Time "$MODIFIED_SOURCE_FILE_3D"

# List of variables to extract
VARIABLES_4D=( alk cadet_arag cadet_calc dic fed fedet fedi felg femd fesm pdi plg pmd psm
            ldon ldop lith lithdet nbact ndet ndi nlg nmd nsm nh4 no3 o2
            po4 srdon srdop sldon sldop sidet silg simd sio4 nsmz nmdz nlgz 
            cased chl co3_ion htotal irr_aclm irr_aclm_sfc irr_aclm_z irr_mem_dp mu_mem_ndi 
            mu_mem_nlg mu_mem_nmd mu_mem_nsm nh3 )  # Add more variables as needed

# Loop through variables and add them to the target file
for VAR in "${VARIABLES_4D[@]}"; do
    # Extract the variable from the last time step and append it directly to the target file
    ncap2 -s "$VAR=double($VAR)" -O "$MODIFIED_SOURCE_FILE_4D" "$MODIFIED_SOURCE_FILE_4D"
    ncks -A -v "$VAR" -d Time,-1 "$MODIFIED_SOURCE_FILE_4D" "$TARGET_FILE"
    
    echo "$VAR variable successfully added to $TARGET_FILE."
done

# List of 3D variables to extract: 
VARIABLES_3D=( cadet_arag_btf cadet_calc_btf lithdet_btf ndet_btf pdet_btf sidet_btf fedet_btf
               nsm_btf nmd_btf nlg_btf ndi_btf fesm_btf femd_btf felg_btf fedi_btf psm_btf 
               pmd_btf plg_btf pdi_btf simd_btf silg_btf )

# Loop through variables and add them to the target file
ncap2 -O -s 'defdim("Layer",1)' $SOURCE_FILE_3D $MODIFIED_SOURCE_FILE_3D
ncrename -d xh,lonh -d yh,lath -d time,Time  "$MODIFIED_SOURCE_FILE_3D"

for VAR_TARGET in "${VARIABLES_3D[@]}"; do
    # get proper variable name
    VAR_SOURCE="f${VAR_TARGET%btf}btm" 

    # Replace name in Modified Source file:
    ncrename -v "$VAR_SOURCE,$VAR_TARGET" "$MODIFIED_SOURCE_FILE_3D"

    # change format to double 
    # ncap2 -s "$VAR_TARGET=double($VAR_TARGET)" "$MODIFIED_SOURCE_FILE_3D" -O "$MODIFIED_SOURCE_FILE_3D"

    # Resize the variables: 
    ncap2 -O -s "${VAR_TARGET}_4D[Time,Layer,lath,lonh] = 0.0;" $MODIFIED_SOURCE_FILE_3D $MODIFIED_SOURCE_FILE_3D
    ncap2 -O -s "${VAR_TARGET}_4D(:,0,:,:) = double(${VAR_TARGET}(:,:,:)); " $MODIFIED_SOURCE_FILE_3D $MODIFIED_SOURCE_FILE_3D
    ncap2 -O -s "${VAR_TARGET} = ${VAR_TARGET}_4D;" $MODIFIED_SOURCE_FILE_3D $MODIFIED_SOURCE_FILE_3D

    # ncap2 -s "cadet_arag_btf_4D[Time,Layer,lath,lonh]=array(0.0,[Time,Layer,lath,lonh])" $MODIFIED_SOURCE_FILE_3D -O $MODIFIED_SOURCE_FILE_3D
    # ncap2 -s "defdim(\"Layer\",1)"  $MODIFIED_SOURCE_FILE_3D -O $MODIFIED_SOURCE_FILE_3D
    # ncap2 -s "${VAR_TARGET}[Time,Layer,lath,lonh]=${VAR_TARGET}(:,:,:)"  $MODIFIED_SOURCE_FILE_3D -O $MODIFIED_SOURCE_FILE_3D
    # ncap2 -s "${VAR}[$VAR.dim(0),Layer,$VAR.dim(1),$VAR.dim(2)] = ${VAR}(:,:,:)"  $MODIFIED_SOURCE_FILE_3D -O $MODIFIED_SOURCE_FILE_3D
    # ncap2 -s "${VAR}=${VAR}.reshape(${VAR}.shape[0],1,${VAR}.shape[1],${VAR}.shape[2])"  $MODIFIED_SOURCE_FILE_3D -O $MODIFIED_SOURCE_FILE_3D
    
    # assigne to target file: 
    ncks -A -d Layer,0,0 -v $VAR_TARGET $MODIFIED_SOURCE_FILE_3D $TARGET_FILE 
    if [ $? -eq 0 ]; then
        echo "Replaced first Layer of $VAR_TARGET in $TARGET_FILE from $VAR_SOURCE in $MODIFIED_SOURCE_FILE_3D."
    else
        echo "Error: Failed to replace $VAR_TARGET in $TARGET_FILE from $VAR_SOURCE."
    fi
done

# Copy Initial Conditions to the INPUT directory
yes | cp -i COBALT_2023_10_spinup_2003_subset.nc INPUT/

echo "All variables processed successfully. cleaning up temporary files ..."

# Remove the modified source files
echo "Removing temporary files ..."
rm -f "$MODIFIED_SOURCE_FILE_4D" "$MODIFIED_SOURCE_FILE_3D"

# set +x 

#  LIST OF TRACERS AND NAMES:
#       alk: Alkalinity
#       cadet_arag: Detrital CaCO3
#       cadet_calc: Detrital CaCO3
#       dic: Dissolved Inorganic Carbon
#       fed: Dissolved Iron
#       fedet: Detrital Iron
#       fedi: Diazotroph Iron
#       felg: Large Phytoplankton Iron
#       femd: Medium Phytoplankton Iron
#       fesm: Small Phytoplankton Iron
#       pdi: Diazotroph Phosphorus
#       plg: Large Phytoplankton Phosphorus
#       pmd: Medium Phytoplankton Phosphorus
#       psm: Small Phytoplankton Phosphorus
#       ldon: labile DON
#       ldop: labile DOP
#       lith: Lithogenic Aluminosilicate
#       lithdet: lithdet
#       nbact: bacterial
#       ndet: ndet
#       ndi: Diazotroph Nitrogen
#       nlg: Large Phytoplankton Nitrogen
#       nmd: Medium Phytoplankton Nitrogen
#       nsm: Small Phytoplankton Nitrogen
#       nh4: Ammonia
#       no3: Nitrate
#       o2: Oxygen
#       po4: Phosphate
#       srdon: Semi-Refractory DON
#       srdop: Semi-Refractory DOP
#       sldon: Semilabile DON
#       sldop: Semilabile DOP
#       sidet: Detrital Silicon
#       silg: Large Phytoplankton Silicon
#       simd: Medium Phytoplankton Silicon
#       sio4: Silicate
#       nsmz: Small Zooplankton Nitrogen
#       nmdz: Medium-sized zooplankton Nitrogen
#       nlgz: large Zooplankton Nitrogen
#       cased: Sediment CaCO3
#       chl: Chlorophyll
#       co3_ion: Carbonate ion
#       cadet_arag_btf: aragonite flux to Sediments
#       cadet_calc_btf: calcite flux to Sediments
#       lithdet_btf: Lith flux to Sediments
#       ndet_btf: N flux to Sediments
#       pdet_btf: P flux to Sediments
#       sidet_btf: SiO2 flux to Sediments
#       fedet_btf: Fe flux to Sediments
#       nsm_btf: nsm flux to Sediments
#       nmd_btf: nmd flux to Sediments
#       nlg_btf: nlg flux to Sediments
#       ndi_btf: ndi flux to Sediments
#       fesm_btf: fesm flux to Sediments
#       femd_btf: femd flux to Sediments
#       felg_btf: felg flux to Sediments
#       fedi_btf: fedi flux to Sediments
#       psm_btf: psm flux to Sediments
#       pmd_btf: pmd flux to Sediments
#       plg_btf: plg flux to Sediments
#       pdi_btf: pdi flux to Sediments
#       simd_btf: simd flux to Sediments
#       silg_btf: silg flux to Sediments
#       htotal: H+ ion concentration
#       irr_aclm: photoacclimation irradiance
#       irr_aclm_sfc: Surface photoacclimation irradiance
#       irr_aclm_z: depth-resolved photoacclim irrad
#       irr_mem_dp: Irradiance memory, diapause
#       mu_mem_ndi: Growth memory
#       mu_mem_nlg: Growth memory
#       mu_mem_nmd: Growth memory
#       mu_mem_nsm: Growth memory
#       nh3: NH3