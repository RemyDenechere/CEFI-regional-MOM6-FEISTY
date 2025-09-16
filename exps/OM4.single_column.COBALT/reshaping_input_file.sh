
# Reshape input files: 

# Modify init_ocean_cobalt.res.nc and GLODAPv2.2016b.oi-filled.20180322.nc 
# to have lon from -180 to 180 instead of 0 to 360: 
cdo sellonlatbox,-180,180,-90,90 INPUT/init_ocean_cobalt.res.nc INPUT/init_ocean_cobalt.res_modified.nc
cdo sellonlatbox,-180,180,-90,90 INPUT/GLODAPv2.2016b.oi-filled.20180322.nc INPUT/GLODAPv2.2016b.oi-filled.20180322_modified.nc

# change _FillValue and missing values for input files: 
ncatted -a _FillValue,,m,f,1.0e20 woa_seasonal_annual_merged_modified.nc 
cdo setmissval,1.e+20f woa_seasonal_annual_merged.nc woa_seasonal_annual_merged_modified.nc"