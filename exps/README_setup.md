# Description of the setup 
Here is a description of the different changes we have made to the model setup to make it run in any Location

---
## Rotation 
While a betaplane centered around a latitude of 0 (F_0=0) works fine for the equator, it isn’t appropriate for high latitude test cases. We therefore use the following parameter in the MOM_override file: 
```
#ROTATION = "2omegasinlat"
#OMEGA = 7.2921E-05
```
The value of $\Omega$ is the angular velocity of the Earth. In other words it is the Earth’s rotation rate [T-1 ~> s-1]. The value of \Omega can be found with the following relationship: $\Omega = \cos(lat) \times V$, with $lat$ the latitude in degree of latitude $V=1,674.4$ km/h the rotation of the earth at the equator.

Potentially the value sigma should be recalculated for the location of the site you are using. 

---
## $K_\textrm{d}$

$K_\textrm{d}$ refers to the difusivity of the layer, it is the sum of the shear-driven mixing, background mixing and tidal mixing. 
The shear-driven mixing
The background mixing 
The tidal mixing

In addition, $K_\textrm{d}$ is multiplied by the term:
$$ \frac{N^2}{N^2 + \Omega ^2}, $$
where $N$ is the buoyancy frequency and $\Omega$ is the angular velocity of the Earth. This allows the buoyancy fluxes to tend to zero in regions of very weak stratification, allowing a no-flux bottom boundary condition to be satisfied.
The buoyancy frequency

---
## Surface temperature and salinity restoring files

When running the MOM6-COBALT model in a 1D fashion some horizontal advection is ignored meaning that there is no advection of heat or salt from surounding waters. In the real ocean, lateral advection helps maintain structure and balance, without it, a column can drift unrealistically over time. Therefore we need to produce salinity and temperature restoring files for each 1D site simulated. 

To generate generate salinity and temperature restoring files for 1-D site use python script: `/project/rdenechere/CEFI-regional-MOM6-FEISTY/exps/datasets/restoring_files/gen_salt_and_temp_restoring_files.py`. 
The script will create a netcdf file for the salt and temperature restoring file containing the name of the specific location define in the script loc : `temp_restore_woa13_decav_loc.nc`

Then copy this file into the INPUT direcotry 
```
yes | cp -i /project/rdenechere/CEFI-regional-MOM6-FEISTY/exps/datasets/restoring_files/temp_restore_woa13_decav_loc.nc
CEFI-regional-MOM6-FEISTY/exps/OM4.single_column.COBALT/INPUT 
```

Make sure that the MOM_override file contains the following file with the specific restoring file name from the location 
```
#override RESTORE_SALINITY = True
#override RESTORE_TEMPERATURE = True
#override SALT_RESTORE_FILE = "salt_restore_woa13_decav_loc.nc"
#override SST_RESTORE_FILE  = "temp_restore_woa13_decav_loc.nc"
```

---
## Nudgging: verticale salinity and temperature restoring 
Nudging refers to the the monthly vertical salinity and temperature restoring. To implement it add the following to the MOM_override file: 
```
#override SPONGE = True
#override SPONGE_UV = False
#override SPONGE_DAMPING_FILE = "damping_full_t_30.nc"
#override SPONGE_IDAMP_VAR = "Idamp"
#override SPONGE_STATE_FILE = "nudging_monthly_woa.nc"
#override SPONGE_PTEMP_VAR = "ptemp_an"
#override SPONGE_SALT_VAR = "s_an"
#override INTERPOLATE_SPONGE_TIME_SPACE = True
#override SPONGE_DATA_ONGRID = True
```

The files `damping_full_t_30.nc` and `nudging_monthly_woa.nc` are needed for the nudgging. `nudging_monthly_woa.nc` contains the monthly restoration value for temperature and salinity for each layer in a particular location.  


---
## Vertical regridding

The Lagrangian-Eulerian (ALE) approach is used for vertical coordinate management in ocean modeling. Rather than being a traditional timestep method, ALE involves periodic regridding and remapping steps to realign the vertical grid with a target configuration, such as geopotential z-surfaces. This process is performed less frequently than other model timesteps to conserve computational resources and minimize numerical mixing errors.

The `REGRIDDING_COORDINATE_MODE = "Z*"` in MOM_override define the type of grid used, where ZSTAR or Z* is the stretched geopotential z*. It is a vertical coordinate framework employed in ocean modeling to enhance the representation of free-surface dynamics. Unlike traditional fixed-depth z-level coordinates, the z* system adjusts the vertical grid in response to changes in sea surface height, thereby maintaining quasi-horizontal coordinate surfaces even when the ocean surface fluctuates due to tides or other forces. This approach mitigates issues such as the vanishing of surface and bottom cells, which can occur in standard z-level models during significant surface elevation changes. 

#### Other options are:  
| MOM_override fields | options | 
| --- | --- | 
| REGRIDDING_COORDINATE_MODE = "option" | Coordinate mode for vertical regridding. Choose among the following |
| | default = "LAYER"  | 
| | LAYER - Isopycnal or stacked shallow water layers| 
| | ZSTAR, Z* - stretched geopotential z* | 
| | SIGMA_SHELF_ZSTAR - stretched geopotential z* ignoring shelf| 
| | SIGMA - terrain following coordinates | 
| | RHO   - continuous isopycnal | 
| | SLIGHT - stretched coordinates above continuous isopycnal |                                 
| | ADAPTIVE - optimize for smooth neutral density surfaces |


---
## Layer description 
Their are 75 layers in MOM6 COBALT, the depth of the layers are defined by the field `#override ALE_COORDINATE_CONFIG = "FNC1:2,6500,6,.01"` in MOM_override, where the value $6500$ is the max depth . If you are running COBALT in a location shallower that 6500 m depth, COBALT will be ran in less than 75 layers. When doing so the layer than are deeper than the site produce a series of vanishingly thin layers at the bottom that may give you some anomalous results. We can consider removing this by changing the depth in ALE_COORDINATE_CONFIG by the depth of the site of intrest. 
Then the field `#DIAG_COORD_DEF_01 = "FNC1:2,4680,6,.01"` should also be modified with the new depth value.

--- 



<!-- First, can you confirm that the variable REGRIDDING_COORDINATE_MODE is indeed Z* in your MOM_parameter_doc.all file?
Next, can you confirm that ALE_COORDINATE_CONFIG is FNC1:2,6500,6,.01?
This basically is a function that specifies the depths of the different Z* layers, which you can see in the variable ALE_RESOLUTION. For example, the first few values are 11*2.0, 2*2.01, 2.02,  -- which means that the first 11 layers are 2m thick, then there are 2 2.01 m thick layers, then 2.02 m thick, and so on. 
Finally, can you add or change the override in your MOM_override file to change the value of DIAG_COORD_DEF_01 to the same as the ALE_COORDINATE_CONFIG?


You should then get all 75 layers outputted with no remapping in the vertical. Charlie's thought is that the negative nitrate values are coming from a single layer and then just gets propagated through to the whole 1000 m remapped layer because of the remapping scheme. But there's no way to really tell that without looking at the un-remapped model run.  -->


<!-- Z* ZSTAR: Stretched Geopotential z*: allow free surface 
Rho is the water density contour layer 
IC on a depth grid then interpolated same for output 
interpolation: https://mom-ocean.github.io/docs/userguide/
if regriding is happening at every time step in MOM6 splits into layer and let them move vertically, the layer are based on the 
density 

regriding https://mom6.readthedocs.io/en/main/api/generated/pages/ALE_Timestep.html -->
