#
# gfortran:
#
# Compiler
FC = gfortran # mpif90 # 
CC = gcc
# Compiler flags
FFLAGS = -O3 -g 
FFLAGS = -Og -pg -g

# netCDF library flags
NETCDF_FLAGS = `nf-config --fflags`
NETCDF_LIBS = `nc-config --libs`
NETCDF_LIBS += `nf-config --flibs`

# OpenMP flag
OPENMP_FLAGS = -fopenmp

# Fortran source file
SOURCE = COBALT_IC_RESTART_public_var.f90 COBALT_IC_RESTART.f90
source_2 = create_netcdf.f90
OUTPUT = restart_COBALT
output2 = netcdf_test

# Targets
all: $(OUTPUT) $(output2)

$(OUTPUT): $(SOURCE)
	$(FC) $(FFLAGS) $(OPENMP_FLAGS) $(SOURCE) $(NETCDF_FLAGS)  -o $(OUTPUT) $(NETCDF_LIBS)

$(output2): $(source_2)
	$(FC) $(FFLAGS) $(OPENMP_FLAGS) $(source_2) $(NETCDF_FLAGS)  -o $(output2) $(NETCDF_LIBS)

clean:
	@echo "Cleaning up *.mod files..."
	rm -rf *.mod
