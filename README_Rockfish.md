# Installation and running on rockfish.
rdenechere 11/21/2023

## Openmpi library on rockfish
The Openmpi library, especially mpirun is not in the path, need to run
```
PATH=$PATH:/usr/lib64/openmpi/bin/
``` 

The command `miprun` should now return
```
mpirun
--------------------------------------------------------------------------
mpirun could not find anything to do.

It is possible that you forgot to specify how many processes to run
via the "-np" argument.
--------------------------------------------------------------------------
```

## Accessing library at runtime

### Directory for compiling
It seems that some of the libraries are not in the path or are not visible from a non admin user, the .mk file has to specify some. INCLUDES and LDFLAGS has been modified:
```
INCLUDES = -I/usr/include/mpich-x86_64/ -I/usr/lib64/gfortran/modules/mpich/
LDFLAGS := -L/usr/lib64/ -lnetcdf -L/usr/lib64/mpich/lib/ -L/usr/lib64/gfortran/modules/mpich/ -lmpi -lmpich -lmpichf90
```

### Shared libraries at runtime
We modified the linux-gnu.env file to give access to the shared libraries while running
```
export LD_LIBRARY_PATH=/usr/lib64/mpich/lib/
```

### Add imbalance tolerance to a namelist
Some compilers (gnu and nvfortran) cannot close some budgets with the demanded accuracy of 1.e-10 (unlike Intel compiler)
```
FATAL: ==>biological source/sink imbalance (generic_COBALT_update_from_source): Carbon
```
That needs some modification to the COBALT code like this:
https://github.com/nikizadehgfdl/ocean_BGC/commit/36ee7df00282fdcf7c243442ec16c03ea52daef2
and then reduce the tolerance in the generic_COBALT_nml to imbalance_tolerance = 1.0e-9.
To turn it off put imbalance_tolerance to 1.0e+9


# Building and Runing CEFI: 
To build the model:
```
cd /project/CEFI-regional-MOM6-FEISTY/builds
./linux-build.bash -m redhat580 -p linux-gnu -t prod -f mom6sis2
```

To run the model: 
```
cd /project/CEFI-regional-MOM6-FEISTY/exps/OM4.single_column.COBALT/
PATH=$PATH:/usr/lib64/openmpi/bin/
PATH=$PATH:/usr/local/src/ncview-2.1.7/
source ../../builds/redhat580/linux-gnu.env 
../../builds/build/redhat580-linux-gnu/ocean_ice/prod/MOM6SIS2 |& tee stdout.redhat
```

Copy FEISTY output to an other directory: 
```
yes | cp -i /project/CEFI-regional-MOM6-FEISTY/exps/OM4.single_column.COBALT/*feisty*.nc ../../../rdenechere/COBALT_output/COBALT_FEISTY/
```

Copy IC to INPUTs
```
yes | cp -i /project/rdenechere/FEISTY-fortran/output/FEISTY_2023_10_spinup_subset.nc /project/CEFI-regional-MOM6-FEISTY/exps/OM4.single_column.COBALT/INPUT/
```

# Run COBALT with FEISTY: 

## Things changed to make COBALT running with FEISTY
    - MOM input file : MAX_FIELDS = 103

## move outputs  
First save the former COBALT output in "COBALT_output/COBALT_no_FEISTY/":
```
yes | cp /project/CEFI-regional-MOM6/exps/OM4.single_column.COBALT/20040101.*.nc /project/rdenechere/COBALT_output/COBALT_no_FEISTY/
```

Then tune COBALT with FEISTY
```
yes | cp /project/rdenechere/COBALT_output/COBALT_FEISTY/*.F90 /project/CEFI-regional-MOM6/src/ocean_BGC/generic_tracers/
```

After running the model save the ouputs, i.e., .nc, in "COBALT_output/COBALT_FEISTY/"
```
yes | cp /project/CEFI-regional-MOM6/exps/OM4.single_column.COBALT/20040101.*.nc /project/rdenechere/COBALT_output/COBALT_FEISTY/
```

## CEFI debug mode first
debug instead of prog 
`./linux-build.bash -m docker -p linux-gnu -t debug -f mom6sis2`


# Some test with CEFI

## Some function and parameters: 
- cobalt_btm : Bottom temperature
- 20040101.ocean_cobalt_fluxes_int.nc : jhploss : predation fluxes from high trophic levels. 
- daily 2D : Contain the biomass of zooplanktons
- ncdump -h 
- ncview 


## Changing time: 
Changed the `input_nml` file under &coupler_nml: days = 0 & month = 12 

### Extra step for changing time

1. Download the original OM4 JRA dataset from [here](https://drive.google.com/file/d/1QLA8a7S_fHWqwsgJLHssO0sRCs37ARxZ). This dataset contains JRA forcing for the entirety of 2004.
```
cd /project/CEFI-regional-MOM6/exps/datasets
wget "https://drive.usercontent.google.com/download?id=1QLA8a7S_fHWqwsgJLHssO0sRCs37ARxZ&export=download&authuser=0" -O OM4_025.JRA.single_column.tar.gz
```
2. Download the COBALTv3 test dataset from [here](https://urldefense.com/v3/__https://gfdl-med.s3.amazonaws.com/OceanBGC_dataset/1d_datasets.tar.gz__;!!Mih3wA!Go8BmwiLS3KDthzWBALgkynXqTpex1An7xcj3rucW1cYpMaXxVEOWIH57Q2ThrVIPFwsiVP5cF1ft5iFXvsjVgyZQA$).

3. Untar files: 
``` 
tar -zxvf OM4_025.JRA.single_column.tar.gz
tar -zxvf 1d_datasets.tar.gz
```
the files should go into the folders ``OM4_025.JRA.single_column`` and ``dataset`` respectively.

4. Replace all the Original OM4.JRA.single_colum's JRA forcing files to the COBALTv3 dataset:
```
yes | cp OM4_025.JRA.single_column_new/*_atmosphericState_OMIP_MRI-JRA55-do-1-4-0_*.nc OM4_025.JRA.si
ngle_column/
```

5. Create symbolic link 
To creat a link to TARGET in the current directory use: ``ln [OPTION]... TARGET``, with `ln` the link function, `-s` the option for symbolic, and `TARGET` of what is linked: 

The current link are visible here: `ll /project/CEFI-regional-MOM6/exps/OM4.single_column.COBALT/INPUT`, however the link is made from the exp directory:
```
cd ../
ln -s datasets/
```
Previous symbolic should be removed to use ln -s; alternativelly we can copy the directory to exp:
```
cp -r /project/CEFI-regional-MOM6/exps/datasets/datasets_1yr_run/ /project/CEFI-regional-MOM6/exps/
```

the link are already created for the directory datasets, an other option is to rename the old dataset: 
```
mv OM4_025.JRA.single_column/ OM4_025.JRA.single_column_old/
mv OceanBGC_dataset/ OceanBGC_dataset_old/
```
then copy the V3 dataset in the dataset folder: 
```
cp -r datasets_1yr_run/OM4_025.JRA.single_column/ datasets/
cp -r datasets_1yr_run/OceanBGC_dataset/ datasets/
rm -rf datasets_1yr_run/
```
then check the link of the INPUT folder: 
```
ll OM4.single_column.COBALT/INPUT/
```

## Creating your own grid: 
See exemple for creating your own grid [here](https://github.com/yichengt900/MOM6_OBGC_examples/blob/main/exps/OM4.single_column/BuildExchangeGrid.csh)


dowload the Fre-NCtools: 
```
cd /project/MOM6_OBGC_examples/
mkdir work 
cd work
git clone https://github.com/NOAA-GFDL/FRE-NCtools.git
cd FRE-NCtools
autoreconf -i
mkdir build && cd build
../configure --prefix=/project/MOM6_OBGC_examples/work/FRE-NCtools
make
make install
```

`Warning:`

PATH=$PATH:/usr/include/


## New experiment 
```
cd /project/MOM6_OBGC_examples/exps/MOM6SIS2_experiments/MOM6SIS2COBALT.single_column
PATH=$PATH:/usr/lib64/openmpi/bin/
source ../../builds/redhat850/linux-gnu.env  
mpirun -n 1 ../../../builds/build/redhat850-linux-gnu/ocean_ice/prod/MOM6SIS2 |& tee stdout.redhat
```

