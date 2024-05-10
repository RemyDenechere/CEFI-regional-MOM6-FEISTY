# Makefile created by mkmf 2022.01.00

CPPDEFS = -Duse_libMPI -Duse_netCDF -DMAXFIELDMETHODS_=800

MK_TEMPLATE = /project/CEFI-regional-MOM6/builds/redhat580/linux-gnu.mk
include $(MK_TEMPLATE)


.DEFAULT:
	-echo $@ does not exist.
all: libfms.a
affinity.o: /project/CEFI-regional-MOM6/builds/../src/FMS/affinity/affinity.c
	$(CC) $(CPPDEFS) $(CPPFLAGS) $(CFLAGS) $(OTHERFLAGS) $(OTHER_CFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/affinity/affinity.c
amip_interp.o: /project/CEFI-regional-MOM6/builds/../src/FMS/amip_interp/amip_interp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h time_interp.o time_manager.o get_cal_time.o horiz_interp.o fms.o constants.o platform.o mpp.o fms2_io.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/amip_interp/amip_interp.F90
astronomy.o: /project/CEFI-regional-MOM6/builds/../src/FMS/astronomy/astronomy.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h fms.o time_manager.o constants.o mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/astronomy/astronomy.F90
atmos_ocean_fluxes.o: /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/atmos_ocean_fluxes.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o fms.o coupler_types.o field_manager.o fm_util.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/coupler/atmos_ocean_fluxes.F90
axis_utils.o: /project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp_io.o mpp.o fms.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils.F90
axis_utils2.o: /project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o fms.o fms2_io.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils2.F90
blackboxio.o: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/blackboxio.F90 mpp_domains.o fms_io_utils.o netcdf_io.o fms_netcdf_domain_io.o fms_netcdf_unstructured_domain_io.o mpp.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/blackboxio.F90
block_control.o: /project/CEFI-regional-MOM6/builds/../src/FMS/block_control/block_control.F90 mpp.o mpp_domains.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/block_control/block_control.F90
cloud_interpolator.o: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/cloud_interpolator.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/drifters/cloud_interpolator.F90
column_diagnostics.o: /project/CEFI-regional-MOM6/builds/../src/FMS/column_diagnostics/column_diagnostics.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h fms.o time_manager.o constants.o mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/column_diagnostics/column_diagnostics.F90
constants.o: /project/CEFI-regional-MOM6/builds/../src/FMS/constants/constants.F90 fmsconstants.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/constants/constants.F90
coupler_types.o: /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/coupler_types.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h fms.o fms2_io.o fms_io.o time_manager.o diag_manager.o data_override.o mpp_domains.o mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/coupler/coupler_types.F90
create_xgrid.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.c /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/constant.h
	$(CC) $(CPPDEFS) $(CPPFLAGS) $(CFLAGS) $(OTHERFLAGS) $(OTHER_CFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic	/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.c
data_override.o: /project/CEFI-regional-MOM6/builds/../src/FMS/data_override/data_override.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h yaml_parser.o constants.o mpp.o horiz_interp.o time_interp_external2.o fms.o axis_utils2.o mpp_domains.o time_manager.o fms2_io.o get_grid_version.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/data_override/data_override.F90
diag_axis.o: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_axis.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h platform.o mpp_domains.o fms.o diag_data.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_axis.F90
diag_data.o: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_data.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h platform.o time_manager.o mpp_domains.o fms.o fms2_io.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_data.F90
diag_grid.o: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_grid.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h platform.o constants.o fms.o mpp.o mpp_domains.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_grid.F90
diag_integral.o: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_integral/diag_integral.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h platform.o time_manager.o mpp.o fms.o fms2_io.o constants.o ensemble_manager.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/diag_integral/diag_integral.F90
diag_manager.o: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h platform.o time_manager.o mpp.o fms.o diag_axis.o diag_util.o diag_data.o diag_table.o diag_output.o diag_grid.o constants.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_manager.F90
diag_output.o: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_output.F90 platform.o mpp_domains.o mpp.o diag_axis.o diag_data.o time_manager.o fms.o fms2_io.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_output.F90
diag_table.o: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_table.F90 fms2_io.o fms.o time_manager.o constants.o diag_data.o diag_util.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_table.F90
diag_util.o: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_util.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h platform.o diag_data.o diag_axis.o diag_output.o diag_grid.o fms.o mpp_domains.o time_manager.o mpp.o constants.o fms2_io.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_util.F90
drifters.o: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/fms_switches.h /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_push.h /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_set_field.h /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_compute_k.h mpp.o mpp_domains.o drifters_core.o drifters_input.o drifters_io.o drifters_comm.o cloud_interpolator.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/drifters -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters.F90
drifters_comm.o: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_comm.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/fms_switches.h mpp.o mpp_domains.o drifters_core.o drifters_input.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/drifters	/project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_comm.F90
drifters_core.o: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_core.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_core.F90
drifters_input.o: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_input.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_input.F90
drifters_io.o: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_io.F90
ensemble_manager.o: /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/ensemble_manager.F90 fms.o mpp.o fms2_io.o fms_io.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/coupler/ensemble_manager.F90
field_manager.o: /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/field_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/parse.inc mpp.o fms.o fms2_io.o fm_yaml.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include -I/project/CEFI-regional-MOM6/builds/../src/FMS/field_manager	/project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/field_manager.F90
fm_util.o: /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_util.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h field_manager.o fms.o mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_util.F90
fm_yaml.o: /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_yaml.F90 yaml_parser.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_yaml.F90
fms.o: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o mpp_domains.o mpp_io.o fms_io.o fms2_io.o memutils.o grid2.o fms_string_utils.o constants.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms.F90
fms2_io.o: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms2_io.F90 fms_io_utils.o netcdf_io.o fms_netcdf_domain_io.o fms_netcdf_unstructured_domain_io.o blackboxio.o mpp.o mpp_domains.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms2_io.F90
fms_affinity.o: /project/CEFI-regional-MOM6/builds/../src/FMS/affinity/fms_affinity.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o fms.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/affinity/fms_affinity.F90
fms_io.o: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/fms_platform.h /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_2d.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_3d.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_4d.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/write_data.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_register_restart_axis.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_setup_one_field.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_register_restart_field.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_save_restart.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_file_name.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_file_unit.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_file_unit.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_field_size.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_field_exist.inc mpp_io.o mpp_domains.o mpp.o platform.o mpp_parameter.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include -I/project/CEFI-regional-MOM6/builds/../src/FMS/fms	/project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io.F90
fms_io_utils.o: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_io_utils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/array_utils.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/array_utils_char.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_data_type_string.inc mpp.o mpp_domains.o platform.o fms_string_utils.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include	/project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_io_utils.F90
fms_netcdf_domain_io.o: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_domain_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_domain_restart_variable.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/domain_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/domain_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compute_global_checksum.inc mpp.o mpp_domains.o fms_io_utils.o netcdf_io.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include	/project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_domain_io.F90
fms_netcdf_unstructured_domain_io.o: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_unstructured_domain_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_unstructured_domain_restart_variable.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/unstructured_domain_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/unstructured_domain_write.inc mpp_domains.o fms_io_utils.o netcdf_io.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include	/project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_unstructured_domain_io.F90
fms_string_utils.o: /project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils.F90 mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils.F90
fms_string_utils_binding.o: /project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils_binding.c
	$(CC) $(CPPDEFS) $(CPPFLAGS) $(CFLAGS) $(OTHERFLAGS) $(OTHER_CFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils_binding.c
fms_yaml_output.o: /project/CEFI-regional-MOM6/builds/../src/FMS/parser/fms_yaml_output.F90
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/parser/fms_yaml_output.F90
fmsconstants.o: /project/CEFI-regional-MOM6/builds/../src/FMS/constants/fmsconstants.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/constants/gfdl_constants.h /project/CEFI-regional-MOM6/builds/../src/FMS/constants/gfs_constants.h /project/CEFI-regional-MOM6/builds/../src/FMS/constants/geos_constants.h platform.o mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/constants	/project/CEFI-regional-MOM6/builds/../src/FMS/constants/fmsconstants.F90
gaussian_topog.o: /project/CEFI-regional-MOM6/builds/../src/FMS/topography/gaussian_topog.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h fms.o constants.o mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/topography/gaussian_topog.F90
get_cal_time.o: /project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/get_cal_time.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h fms.o time_manager.o mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/get_cal_time.F90
get_grid_version.o: /project/CEFI-regional-MOM6/builds/../src/FMS/data_override/get_grid_version.F90 constants.o mpp.o mpp_domains.o fms2_io.o mosaic2.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/data_override/get_grid_version.F90
gradient.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o constants.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient.F90
gradient_c2l.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient_c2l.c /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/constant.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient_c2l.h
	$(CC) $(CPPDEFS) $(CPPFLAGS) $(CFLAGS) $(OTHERFLAGS) $(OTHER_CFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic	/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient_c2l.c
grid.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/grid.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o constants.o fms_io.o mosaic.o mpp_domains.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/grid.F90
grid2.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/grid2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o constants.o fms2_io.o fms_string_utils.o mosaic2.o mpp_domains.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/grid2.F90
horiz_interp.o: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h fms.o mpp.o constants.o horiz_interp_type.o horiz_interp_conserve.o horiz_interp_bilinear.o horiz_interp_bicubic.o horiz_interp_spherical.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp.F90
horiz_interp_bicubic.o: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bicubic.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o fms.o horiz_interp_type.o constants.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bicubic.F90
horiz_interp_bilinear.o: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bilinear.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o fms.o constants.o horiz_interp_type.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bilinear.F90
horiz_interp_conserve.o: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_conserve.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/fms_platform.h /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o fms.o grid2.o constants.o horiz_interp_type.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_conserve.F90
horiz_interp_spherical.o: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_spherical.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o fms.o constants.o horiz_interp_type.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_spherical.F90
horiz_interp_type.o: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_type.F90 mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_type.F90
interp.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/interp.c /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/interp.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.h
	$(CC) $(CPPDEFS) $(CPPFLAGS) $(CFLAGS) $(OTHERFLAGS) $(OTHER_CFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic	/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/interp.c
interpolator.o: /project/CEFI-regional-MOM6/builds/../src/FMS/interpolator/interpolator.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o mpp_domains.o diag_manager.o fms.o fms2_io.o horiz_interp.o time_manager.o time_interp.o constants.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/interpolator/interpolator.F90
libFMS.o: /project/CEFI-regional-MOM6/builds/../src/FMS/libFMS.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h fms_affinity.o amip_interp.o astronomy.o axis_utils2.o block_control.o column_diagnostics.o coupler_types.o ensemble_manager.o atmos_ocean_fluxes.o data_override.o diag_integral.o diag_manager.o xgrid.o stock_constants.o field_manager.o fm_util.o fms2_io.o fms.o horiz_interp.o horiz_interp_type.o interpolator.o memutils.o monin_obukhov.o monin_obukhov_inter.o mosaic2.o grid2.o gradient.o mpp.o mpp_parameter.o mpp_data.o mpp_utilities.o mpp_memutils.o mpp_efp.o mpp_domains.o yaml_parser.o platform.o random_numbers.o sat_vapor_pres.o fms_string_utils.o time_interp.o time_interp_external2.o time_manager.o get_cal_time.o gaussian_topog.o topography.o tracer_manager.o tridiagonal.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/libFMS.F90
memutils.o: /project/CEFI-regional-MOM6/builds/../src/FMS/memutils/memutils.F90 mpp.o mpp_memutils.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/memutils/memutils.F90
mersennetwister.o: /project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/mersennetwister.F90
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/mersennetwister.F90
monin_obukhov.o: /project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h constants.o mpp.o fms.o monin_obukhov_inter.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov.F90
monin_obukhov_inter.o: /project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov_inter.F90
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov_inter.F90
mosaic.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o mpp_io.o fms_io.o constants.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic.F90
mosaic2.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/mosaic2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o mpp_domains.o constants.o fms2_io.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/mosaic2.F90
mosaic_util.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.c /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/constant.h
	$(CC) $(CPPDEFS) $(CPPFLAGS) $(CFLAGS) $(OTHERFLAGS) $(OTHER_CFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic	/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.c
mpp.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/system_clock.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util_mpi.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util_nocomm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_a_a.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_a_s.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_s_a.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_s_s.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm_mpi.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_reduce_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_mpi_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_ad.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_alltoall_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_type_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm_nocomm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_reduce_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_nocomm_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_alltoall_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_type_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum_int.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum_scalar.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_gather.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_scatter.h mpp_parameter.o mpp_data.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include -I/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp.F90
mpp_data.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_data.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_data_mpi.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_data_nocomm.inc mpp_parameter.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include -I/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_data.F90
mpp_domains.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_domains.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_define_nest_domains.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_util.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_comm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_define.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_misc.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D_nonblock.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_nonblock.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV_nonblock.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_check.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_checkV.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_nest_domains.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_nest.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_redistribute.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_get_boundary.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_get_boundary_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_get_boundary.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_get_boundary_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_group_update.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/group_update_pack.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/group_update_unpack.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_reduce.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_reduce.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum_tl.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_global_field.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_global_field_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_unstruct_domain.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_unstruct_pass_data.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field_ug.h mpp_parameter.o mpp_data.o mpp.o mpp_memutils.o mpp_efp.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include -I/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_domains.F90
mpp_efp.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_efp.F90 mpp.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_efp.F90
mpp_io.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_util.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_misc.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_connect.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_2Ddecomp.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_compressed.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_distributed_ascii.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_distributed_ascii.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_2Ddecomp.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_compressed.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_unlimited_axis.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_unstructured_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_unstructured_read.inc mpp_parameter.o mpp.o mpp_domains.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include -I/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_io.F90
mpp_memuse.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memuse.c
	$(CC) $(CPPDEFS) $(CPPFLAGS) $(CFLAGS) $(OTHERFLAGS) $(OTHER_CFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memuse.c
mpp_memutils.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memutils.F90 mpp.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memutils.F90
mpp_parameter.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_parameter.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_parameter.F90
mpp_pset.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_pset.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/fms_platform.h mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_pset.F90
mpp_utilities.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_utilities.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_utilities.F90
netcdf_io.o: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/netcdf_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_add_restart_variable.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_read_data.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_write_data.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_global_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_variable_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_global_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_variable_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compressed_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compressed_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/scatter_data_bc.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/gather_data_bc.inc mpp.o fms_io_utils.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include	/project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/netcdf_io.F90
platform.o: /project/CEFI-regional-MOM6/builds/../src/FMS/platform/platform.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/fms_platform.h
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/platform/platform.F90
quicksort.o: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/quicksort.F90
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/drifters/quicksort.F90
random_numbers.o: /project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/random_numbers.F90 mersennetwister.o time_manager.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/random_numbers.F90
read_mosaic.o: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/read_mosaic.c /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/read_mosaic.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/constant.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.h
	$(CC) $(CPPDEFS) $(CPPFLAGS) $(CFLAGS) $(OTHERFLAGS) $(OTHER_CFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic	/project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/read_mosaic.c
sat_vapor_pres.o: /project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h constants.o fms.o mpp.o sat_vapor_pres_k.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres.F90
sat_vapor_pres_k.o: /project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres_k.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h fms.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres_k.F90
stock_constants.o: /project/CEFI-regional-MOM6/builds/../src/FMS/exchange/stock_constants.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o fms.o time_manager.o diag_manager.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/exchange/stock_constants.F90
time_interp.o: /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h time_manager.o fms.o mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp.F90
time_interp_external.o: /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/fms_platform.h /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h fms.o mpp.o mpp_io.o time_manager.o get_cal_time.o mpp_domains.o time_interp.o axis_utils.o platform.o horiz_interp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external.F90
time_interp_external2.o: /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h platform.o fms.o mpp.o time_manager.o get_cal_time.o mpp_domains.o time_interp.o axis_utils2.o horiz_interp.o fms2_io.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external2.F90
time_manager.o: /project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/time_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h platform.o constants.o fms.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/time_manager.F90
topography.o: /project/CEFI-regional-MOM6/builds/../src/FMS/topography/topography.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h gaussian_topog.o horiz_interp.o fms.o fms2_io.o constants.o mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/topography/topography.F90
tracer_manager.o: /project/CEFI-regional-MOM6/builds/../src/FMS/tracer_manager/tracer_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h mpp.o fms.o field_manager.o platform.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/tracer_manager/tracer_manager.F90
tridiagonal.o: /project/CEFI-regional-MOM6/builds/../src/FMS/tridiagonal/tridiagonal.F90
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/tridiagonal/tridiagonal.F90
xgrid.o: /project/CEFI-regional-MOM6/builds/../src/FMS/exchange/xgrid.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h fms.o mpp.o mpp_domains.o constants.o mosaic2.o stock_constants.o gradient.o fms2_io.o platform.o time_manager.o diag_manager.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c -I/project/CEFI-regional-MOM6/builds/../src/FMS/include	/project/CEFI-regional-MOM6/builds/../src/FMS/exchange/xgrid.F90
yaml_output_functions.o: /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_output_functions.c
	$(CC) $(CPPDEFS) $(CPPFLAGS) $(CFLAGS) $(OTHERFLAGS) $(OTHER_CFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_output_functions.c
yaml_parser.o: /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser.F90 fms.o fms_string_utils.o platform.o mpp.o
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) $(OTHERFLAGS) $(OTHER_FFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser.F90
yaml_parser_binding.o: /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser_binding.c
	$(CC) $(CPPDEFS) $(CPPFLAGS) $(CFLAGS) $(OTHERFLAGS) $(OTHER_CFLAGS) -c	/project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser_binding.c
./mpp_reduce_nocomm.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_reduce_nocomm.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_reduce_nocomm.h .
./fms_switches.h: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/fms_switches.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/fms_switches.h .
./mpp_global_sum_tl.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum_tl.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum_tl.h .
./mpp_comm.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm.inc .
./mpp_chksum_int.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum_int.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum_int.h .
./mpp_type_mpi.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_type_mpi.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_type_mpi.h .
./read_mosaic.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/read_mosaic.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/read_mosaic.h .
./mpp_sum_mpi_ad.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_mpi_ad.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_mpi_ad.h .
./mpp_read_compressed.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_compressed.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_compressed.h .
./write_data.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/write_data.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/write_data.inc .
./axis_utils.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils.F90 .
./fms_string_utils.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils.F90 .
./mpp_do_check.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_check.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_check.h .
./group_update_pack.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/group_update_pack.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/group_update_pack.inc .
./domain_write.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/domain_write.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/domain_write.inc .
./system_clock.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/system_clock.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/system_clock.h .
./mpp_comm_nocomm.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm_nocomm.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm_nocomm.inc .
./domain_read.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/domain_read.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/domain_read.inc .
./mpp_read_distributed_ascii.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_distributed_ascii.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_distributed_ascii.inc .
./mpp_data_mpi.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_data_mpi.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_data_mpi.inc .
./mpp_error_s_a.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_s_a.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_s_a.h .
./constant.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/constant.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/constant.h .
./mpp_domains_comm.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_comm.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_comm.inc .
./diag_integral.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_integral/diag_integral.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/diag_integral/diag_integral.F90 .
./drifters_push.h: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_push.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_push.h .
./diag_output.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_output.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_output.F90 .
./mpp_read_distributed_ascii.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_distributed_ascii.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_distributed_ascii.h .
./mosaic_util.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.h .
./mpp_transmit.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit.inc .
./diag_table.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_table.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_table.F90 .
./scatter_data_bc.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/scatter_data_bc.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/scatter_data_bc.inc .
./netcdf_read_data.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_read_data.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_read_data.inc .
./mpp_error_a_s.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_a_s.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_a_s.h .
./mpp_gather.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_gather.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_gather.h .
./drifters_core.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_core.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_core.F90 .
./grid2.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/grid2.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/grid2.F90 .
./mpp_chksum_scalar.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum_scalar.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum_scalar.h .
./mpp_update_nest_domains.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_nest_domains.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_nest_domains.h .
./mpp_util_mpi.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util_mpi.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util_mpi.inc .
./read_data_3d.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_3d.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_3d.inc .
./fms_string_utils_binding.c: /project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils_binding.c
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils_binding.c .
./interp.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/interp.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/interp.h .
./parse.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/parse.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/parse.inc .
./yaml_output_functions.c: /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_output_functions.c
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_output_functions.c .
./mpp_domains_util.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_util.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_util.inc .
./mpp_util.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util.inc .
./create_xgrid.c: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.c
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.c .
./gather_data_bc.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/gather_data_bc.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/gather_data_bc.inc .
./memutils.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/memutils/memutils.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/memutils/memutils.F90 .
./blackboxio.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/blackboxio.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/blackboxio.F90 .
./netcdf_add_restart_variable.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_add_restart_variable.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_add_restart_variable.inc .
./coupler_types.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/coupler_types.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/coupler_types.F90 .
./mpp_parameter.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_parameter.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_parameter.F90 .
./get_global_attribute.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_global_attribute.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_global_attribute.inc .
./mpp_update_domains2D_ad.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D_ad.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D_ad.h .
./mpp_reduce_mpi.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_reduce_mpi.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_reduce_mpi.h .
./diag_grid.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_grid.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_grid.F90 .
./fms_io_unstructured_field_exist.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_field_exist.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_field_exist.inc .
./mpp_error_a_a.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_a_a.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_a_a.h .
./affinity.c: /project/CEFI-regional-MOM6/builds/../src/FMS/affinity/affinity.c
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/affinity/affinity.c .
./mpp_transmit_mpi.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit_mpi.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit_mpi.h .
./drifters_set_field.h: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_set_field.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_set_field.h .
./fms_io.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io.F90 .
./register_variable_attribute.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_variable_attribute.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_variable_attribute.inc .
./mpp_do_global_field_ad.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_global_field_ad.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_global_field_ad.h .
./unstructured_domain_read.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/unstructured_domain_read.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/unstructured_domain_read.inc .
./mpp_get_boundary_ad.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_get_boundary_ad.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_get_boundary_ad.h .
./array_utils.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/array_utils.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/array_utils.inc .
./geos_constants.h: /project/CEFI-regional-MOM6/builds/../src/FMS/constants/geos_constants.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/constants/geos_constants.h .
./mpp_write_compressed.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_compressed.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_compressed.h .
./compute_global_checksum.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compute_global_checksum.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compute_global_checksum.inc .
./fms2_io.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms2_io.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms2_io.F90 .
./unstructured_domain_write.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/unstructured_domain_write.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/unstructured_domain_write.inc .
./mpp_global_sum.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum.h .
./file_version.h: /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h .
./libFMS.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/libFMS.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/libFMS.F90 .
./compressed_write.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compressed_write.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compressed_write.inc .
./column_diagnostics.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/column_diagnostics/column_diagnostics.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/column_diagnostics/column_diagnostics.F90 .
./mpp_util_nocomm.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util_nocomm.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util_nocomm.inc .
./mpp_sum_mpi.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_mpi.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_mpi.h .
./mpp_update_domains2D_nonblock.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D_nonblock.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D_nonblock.h .
./fms_netcdf_domain_io.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_domain_io.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_domain_io.F90 .
./mpp_io_connect.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_connect.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_connect.inc .
./mpp_io_unstructured_write.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_unstructured_write.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_unstructured_write.inc .
./horiz_interp_bilinear.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bilinear.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bilinear.F90 .
./gfdl_constants.h: /project/CEFI-regional-MOM6/builds/../src/FMS/constants/gfdl_constants.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/constants/gfdl_constants.h .
./fms_io_unstructured_register_restart_field.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_register_restart_field.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_register_restart_field.inc .
./read_data_4d.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_4d.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_4d.inc .
./mpp_do_global_field.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_global_field.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_global_field.h .
./platform.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/platform/platform.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/platform/platform.F90 .
./mpp_define_nest_domains.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_define_nest_domains.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_define_nest_domains.inc .
./get_cal_time.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/get_cal_time.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/get_cal_time.F90 .
./array_utils_char.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/array_utils_char.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/array_utils_char.inc .
./topography.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/topography/topography.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/topography/topography.F90 .
./netcdf_write_data.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_write_data.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_write_data.inc .
./gradient_c2l.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient_c2l.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient_c2l.h .
./drifters_input.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_input.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_input.F90 .
./mpp_utilities.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_utilities.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_utilities.F90 .
./drifters_io.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_io.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_io.F90 .
./mpp_domains.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_domains.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_domains.F90 .
./mosaic2.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/mosaic2.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/mosaic2.F90 .
./block_control.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/block_control/block_control.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/block_control/block_control.F90 .
./grid.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/grid.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/grid.F90 .
./fms_yaml_output.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/parser/fms_yaml_output.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/parser/fms_yaml_output.F90 .
./mpp_do_updateV_nonblock.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV_nonblock.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV_nonblock.h .
./mpp_global_field_ad.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field_ad.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field_ad.h .
./get_variable_attribute.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_variable_attribute.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_variable_attribute.inc .
./mpp_sum.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum.inc .
./mpp_chksum.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum.h .
./get_grid_version.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/data_override/get_grid_version.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/data_override/get_grid_version.F90 .
./mpp_do_redistribute.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_redistribute.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_redistribute.h .
./fms_affinity.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/affinity/fms_affinity.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/affinity/fms_affinity.F90 .
./mpp_unstruct_pass_data.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_unstruct_pass_data.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_unstruct_pass_data.h .
./mpp.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp.F90 .
./fms_io_unstructured_get_file_name.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_file_name.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_file_name.inc .
./sat_vapor_pres_k.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres_k.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres_k.F90 .
./mpp_error_s_s.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_s_s.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_s_s.h .
./random_numbers.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/random_numbers.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/random_numbers.F90 .
./interp.c: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/interp.c
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/interp.c .
./horiz_interp_spherical.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_spherical.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_spherical.F90 .
./mpp_do_update_nest.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_nest.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_nest.h .
./tridiagonal.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/tridiagonal/tridiagonal.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/tridiagonal/tridiagonal.F90 .
./gradient_c2l.c: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient_c2l.c
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient_c2l.c .
./mpp_sum_ad.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_ad.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_ad.inc .
./mpp_global_field_ug.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field_ug.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field_ug.h .
./gfs_constants.h: /project/CEFI-regional-MOM6/builds/../src/FMS/constants/gfs_constants.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/constants/gfs_constants.h .
./fm_yaml.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_yaml.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_yaml.F90 .
./mpp_write_unlimited_axis.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_unlimited_axis.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_unlimited_axis.h .
./horiz_interp.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp.F90 .
./read_data_2d.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_2d.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_2d.inc .
./mpp_write_2Ddecomp.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_2Ddecomp.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_2Ddecomp.h .
./drifters_comm.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_comm.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_comm.F90 .
./mpp_group_update.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_group_update.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_group_update.h .
./mpp_do_updateV_ad.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV_ad.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV_ad.h .
./read_mosaic.c: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/read_mosaic.c
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/read_mosaic.c .
./cloud_interpolator.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/cloud_interpolator.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/cloud_interpolator.F90 .
./mpp_do_checkV.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_checkV.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_checkV.h .
./fms_io_utils.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_io_utils.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_io_utils.F90 .
./yaml_parser_binding.c: /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser_binding.c
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser_binding.c .
./register_unstructured_domain_restart_variable.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_unstructured_domain_restart_variable.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_unstructured_domain_restart_variable.inc .
./fms_io_unstructured_register_restart_axis.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_register_restart_axis.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_register_restart_axis.inc .
./compressed_read.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compressed_read.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compressed_read.inc .
./xgrid.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/exchange/xgrid.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/exchange/xgrid.F90 .
./tracer_manager.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/tracer_manager/tracer_manager.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/tracer_manager/tracer_manager.F90 .
./fmsconstants.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/constants/fmsconstants.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/constants/fmsconstants.F90 .
./mpp_unstruct_domain.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_unstruct_domain.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_unstruct_domain.inc .
./gradient.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient.F90 .
./interpolator.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/interpolator/interpolator.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/interpolator/interpolator.F90 .
./ensemble_manager.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/ensemble_manager.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/ensemble_manager.F90 .
./register_domain_restart_variable.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_domain_restart_variable.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_domain_restart_variable.inc .
./mpp_get_boundary.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_get_boundary.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_get_boundary.h .
./mpp_io.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_io.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_io.F90 .
./sat_vapor_pres.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres.F90 .
./time_interp_external.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external.F90 .
./mpp_memuse.c: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memuse.c
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memuse.c .
./fms_io_unstructured_read.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_read.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_read.inc .
./mpp_global_reduce.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_reduce.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_reduce.h .
./fms_io_unstructured_save_restart.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_save_restart.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_save_restart.inc .
./atmos_ocean_fluxes.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/atmos_ocean_fluxes.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/atmos_ocean_fluxes.F90 .
./constants.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/constants/constants.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/constants/constants.F90 .
./fms_platform.h: /project/CEFI-regional-MOM6/builds/../src/FMS/include/fms_platform.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/include/fms_platform.h .
./monin_obukhov_inter.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov_inter.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov_inter.F90 .
./mpp_do_update_ad.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_ad.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_ad.h .
./mpp_pset.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_pset.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_pset.F90 .
./fms_netcdf_unstructured_domain_io.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_unstructured_domain_io.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_unstructured_domain_io.F90 .
./fm_util.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_util.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_util.F90 .
./diag_data.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_data.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_data.F90 .
./mpp_memutils.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memutils.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memutils.F90 .
./mosaic.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic.F90 .
./diag_manager.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_manager.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_manager.F90 .
./fms.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms.F90 .
./drifters_compute_k.h: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_compute_k.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_compute_k.h .
./amip_interp.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/amip_interp/amip_interp.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/amip_interp/amip_interp.F90 .
./mpp_global_sum_ad.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum_ad.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum_ad.h .
./diag_axis.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_axis.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_axis.F90 .
./data_override.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/data_override/data_override.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/data_override/data_override.F90 .
./mpp_domains_reduce.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_reduce.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_reduce.inc .
./mpp_domains_define.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_define.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_define.inc .
./mpp_scatter.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_scatter.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_scatter.h .
./time_interp.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp.F90 .
./mpp_do_get_boundary.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_get_boundary.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_get_boundary.h .
./stock_constants.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/exchange/stock_constants.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/exchange/stock_constants.F90 .
./axis_utils2.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils2.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils2.F90 .
./mpp_alltoall_mpi.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_alltoall_mpi.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_alltoall_mpi.h .
./field_manager.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/field_manager.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/field_manager.F90 .
./mpp_do_updateV.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV.h .
./fms_io_unstructured_file_unit.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_file_unit.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_file_unit.inc .
./diag_util.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_util.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_util.F90 .
./mpp_data.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_data.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_data.F90 .
./gaussian_topog.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/topography/gaussian_topog.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/topography/gaussian_topog.F90 .
./mpp_write.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write.h .
./mersennetwister.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/mersennetwister.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/mersennetwister.F90 .
./mpp_do_update_nonblock.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_nonblock.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_nonblock.h .
./fms_io_unstructured_get_file_unit.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_file_unit.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_file_unit.inc .
./mpp_io_util.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_util.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_util.inc .
./horiz_interp_bicubic.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bicubic.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bicubic.F90 .
./mpp_comm_mpi.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm_mpi.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm_mpi.inc .
./mpp_global_field.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field.h .
./mpp_efp.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_efp.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_efp.F90 .
./register_global_attribute.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_global_attribute.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_global_attribute.inc .
./mpp_update_domains2D.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D.h .
./mpp_domains_misc.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_misc.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_misc.inc .
./quicksort.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/quicksort.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/quicksort.F90 .
./fms_io_unstructured_get_field_size.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_field_size.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_field_size.inc .
./drifters.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters.F90 .
./netcdf_io.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/netcdf_io.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/netcdf_io.F90 .
./mpp_sum_nocomm_ad.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_nocomm_ad.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_nocomm_ad.h .
./mpp_transmit_nocomm.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit_nocomm.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit_nocomm.h .
./mosaic_util.c: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.c
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.c .
./time_interp_external2.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external2.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external2.F90 .
./mpp_sum_nocomm.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_nocomm.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_nocomm.h .
./horiz_interp_conserve.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_conserve.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_conserve.F90 .
./mpp_type_nocomm.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_type_nocomm.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_type_nocomm.h .
./yaml_parser.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser.F90 .
./get_data_type_string.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_data_type_string.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_data_type_string.inc .
./mpp_io_write.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_write.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_write.inc .
./mpp_io_misc.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_misc.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_misc.inc .
./group_update_unpack.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/group_update_unpack.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/group_update_unpack.inc .
./mpp_io_read.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_read.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_read.inc .
./mpp_alltoall_nocomm.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_alltoall_nocomm.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_alltoall_nocomm.h .
./mpp_data_nocomm.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_data_nocomm.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_data_nocomm.inc .
./create_xgrid.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.h .
./fms_io_unstructured_setup_one_field.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_setup_one_field.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_setup_one_field.inc .
./mpp_do_get_boundary_ad.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_get_boundary_ad.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_get_boundary_ad.h .
./mpp_read_2Ddecomp.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_2Ddecomp.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_2Ddecomp.h .
./astronomy.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/astronomy/astronomy.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/astronomy/astronomy.F90 .
./mpp_io_unstructured_read.inc: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_unstructured_read.inc
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_unstructured_read.inc .
./horiz_interp_type.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_type.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_type.F90 .
./time_manager.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/time_manager.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/time_manager.F90 .
./monin_obukhov.F90: /project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov.F90
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov.F90 .
./mpp_do_update.h: /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update.h
	cp /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update.h .
SRC = /project/CEFI-regional-MOM6/builds/../src/FMS/tracer_manager/tracer_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_comm.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/affinity/fms_affinity.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils_binding.c /project/CEFI-regional-MOM6/builds/../src/FMS/exchange/stock_constants.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/time_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient_c2l.c /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_efp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/interpolator/interpolator.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/random_numbers.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memutils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/grid2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/mosaic2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/astronomy/astronomy.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.c /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_core.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.c /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_output.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/data_override/get_grid_version.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/interp.c /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_util.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_output_functions.c /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/blackboxio.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/data_override/data_override.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/parser/fms_yaml_output.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_data.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/cloud_interpolator.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_pset.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_yaml.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memuse.c /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_io_utils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/read_mosaic.c /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bicubic.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_spherical.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/block_control/block_control.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/amip_interp/amip_interp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/grid.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_conserve.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/platform/platform.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_utilities.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/affinity/affinity.c /project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/field_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bilinear.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/atmos_ocean_fluxes.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/diag_integral/diag_integral.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_domain_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_parameter.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_input.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/column_diagnostics/column_diagnostics.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_data.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/constants/constants.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_type.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser_binding.c /project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres_k.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_util.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/netcdf_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms2_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/exchange/xgrid.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/tridiagonal/tridiagonal.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_unstructured_domain_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/get_cal_time.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_axis.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/ensemble_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/topography/topography.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_table.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov_inter.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/quicksort.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/coupler_types.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/memutils/memutils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/topography/gaussian_topog.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/constants/fmsconstants.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/libFMS.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/mersennetwister.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_domains.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_grid.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_push.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_distributed_ascii.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/domain_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm_nocomm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/system_clock.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_distributed_ascii.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/domain_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_data_mpi.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_s_a.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/constant.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_comm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_check.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/group_update_pack.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_reduce_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/fms_switches.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum_tl.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum_int.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/read_mosaic.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_mpi_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_type_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_compressed.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/write_data.inc /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_set_field.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_global_field_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_variable_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_get_boundary_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/unstructured_domain_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/array_utils.inc /project/CEFI-regional-MOM6/builds/../src/FMS/constants/geos_constants.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_compressed.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_global_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_reduce_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_field_exist.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_a_a.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_util.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/gather_data_bc.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_add_restart_variable.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_gather.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/scatter_data_bc.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_a_s.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_read_data.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum_scalar.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_3d.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_nest_domains.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util_mpi.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/interp.h /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/parse.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_write_data.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient_c2l.h /project/CEFI-regional-MOM6/builds/../src/FMS/constants/gfdl_constants.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_register_restart_field.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_4d.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_define_nest_domains.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_global_field.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/array_utils_char.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util_nocomm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D_nonblock.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_connect.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_unstructured_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compute_global_checksum.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/unstructured_domain_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum.h /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compressed_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_nest.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_ad.inc /project/CEFI-regional-MOM6/builds/../src/FMS/constants/gfs_constants.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field_ug.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_s_s.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_unstruct_pass_data.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_file_name.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV_nonblock.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_variable_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_redistribute.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_get_boundary.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_unstruct_domain.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_domain_restart_variable.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_checkV.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_register_restart_axis.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_unstructured_domain_restart_variable.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compressed_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_unlimited_axis.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_2d.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_2Ddecomp.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_group_update.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_reduce.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_define.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_scatter.h /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_compute_k.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_reduce.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_save_restart.inc /project/CEFI-regional-MOM6/builds/../src/FMS/include/fms_platform.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_misc.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_field_size.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_nocomm_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm_mpi.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_global_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_nonblock.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_file_unit.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_util.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_get_boundary.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_alltoall_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_file_unit.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_unstructured_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_setup_one_field.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_get_boundary_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_2Ddecomp.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_data_type_string.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_misc.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/group_update_unpack.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_alltoall_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_data_nocomm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_type_nocomm.h
OBJ = tracer_manager.o mosaic.o drifters_comm.o fms_affinity.o fms_string_utils_binding.o stock_constants.o time_manager.o gradient_c2l.o mpp_efp.o interpolator.o time_interp_external.o random_numbers.o gradient.o monin_obukhov.o mpp_memutils.o grid2.o mosaic2.o drifters.o axis_utils.o astronomy.o create_xgrid.o drifters_core.o mosaic_util.o diag_output.o get_grid_version.o interp.o diag_manager.o fm_util.o mpp.o yaml_output_functions.o time_interp_external2.o blackboxio.o data_override.o fms_yaml_output.o diag_data.o cloud_interpolator.o mpp_pset.o fm_yaml.o mpp_memuse.o fms_io_utils.o read_mosaic.o horiz_interp_bicubic.o horiz_interp.o fms.o horiz_interp_spherical.o block_control.o amip_interp.o grid.o horiz_interp_conserve.o platform.o mpp_utilities.o affinity.o sat_vapor_pres.o field_manager.o horiz_interp_bilinear.o fms_string_utils.o atmos_ocean_fluxes.o diag_integral.o fms_netcdf_domain_io.o mpp_parameter.o yaml_parser.o drifters_input.o column_diagnostics.o mpp_data.o constants.o horiz_interp_type.o yaml_parser_binding.o sat_vapor_pres_k.o axis_utils2.o diag_util.o netcdf_io.o fms2_io.o xgrid.o tridiagonal.o fms_netcdf_unstructured_domain_io.o get_cal_time.o diag_axis.o ensemble_manager.o topography.o diag_table.o monin_obukhov_inter.o time_interp.o mpp_io.o quicksort.o coupler_types.o memutils.o gaussian_topog.o fmsconstants.o fms_io.o libFMS.o drifters_io.o mersennetwister.o mpp_domains.o diag_grid.o
OFF = /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_reduce_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/fms_switches.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum_tl.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum_int.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_type_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/read_mosaic.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_mpi_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_compressed.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/write_data.inc /project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_check.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/group_update_pack.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/domain_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/system_clock.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm_nocomm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/domain_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_distributed_ascii.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_data_mpi.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_s_a.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/constant.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_comm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/diag_integral/diag_integral.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_push.h /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_output.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_distributed_ascii.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit.inc /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_table.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/scatter_data_bc.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_read_data.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_a_s.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_gather.h /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_core.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/grid2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum_scalar.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_nest_domains.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util_mpi.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_3d.inc /project/CEFI-regional-MOM6/builds/../src/FMS/string_utils/fms_string_utils_binding.c /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/interp.h /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/parse.inc /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_output_functions.c /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_util.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.c /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/gather_data_bc.inc /project/CEFI-regional-MOM6/builds/../src/FMS/memutils/memutils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/blackboxio.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_add_restart_variable.inc /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/coupler_types.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_parameter.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_global_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_reduce_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_grid.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_field_exist.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_a_a.h /project/CEFI-regional-MOM6/builds/../src/FMS/affinity/affinity.c /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_set_field.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_variable_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_global_field_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/unstructured_domain_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_get_boundary_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/array_utils.inc /project/CEFI-regional-MOM6/builds/../src/FMS/constants/geos_constants.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_compressed.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compute_global_checksum.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms2_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/unstructured_domain_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum.h /project/CEFI-regional-MOM6/builds/../src/FMS/include/file_version.h /project/CEFI-regional-MOM6/builds/../src/FMS/libFMS.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compressed_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/column_diagnostics/column_diagnostics.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_util_nocomm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D_nonblock.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_domain_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_connect.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_unstructured_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bilinear.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/constants/gfdl_constants.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_register_restart_field.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_4d.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_global_field.h /project/CEFI-regional-MOM6/builds/../src/FMS/platform/platform.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_define_nest_domains.inc /project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/get_cal_time.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/array_utils_char.inc /project/CEFI-regional-MOM6/builds/../src/FMS/topography/topography.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/netcdf_write_data.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient_c2l.h /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_input.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_utilities.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_domains.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic2/mosaic2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/block_control/block_control.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/grid.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/parser/fms_yaml_output.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV_nonblock.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_variable_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_chksum.h /project/CEFI-regional-MOM6/builds/../src/FMS/data_override/get_grid_version.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_redistribute.h /project/CEFI-regional-MOM6/builds/../src/FMS/affinity/fms_affinity.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_unstruct_pass_data.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_file_name.inc /project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres_k.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_error_s_s.h /project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/random_numbers.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/interp.c /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_spherical.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_nest.h /project/CEFI-regional-MOM6/builds/../src/FMS/tridiagonal/tridiagonal.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient_c2l.c /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_ad.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field_ug.h /project/CEFI-regional-MOM6/builds/../src/FMS/constants/gfs_constants.h /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_yaml.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_unlimited_axis.h /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms/read_data_2d.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write_2Ddecomp.h /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_comm.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_group_update.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/read_mosaic.c /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/cloud_interpolator.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_checkV.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_io_utils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser_binding.c /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_unstructured_domain_restart_variable.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_register_restart_axis.inc /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/compressed_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/exchange/xgrid.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/tracer_manager/tracer_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/constants/fmsconstants.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_unstruct_domain.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/gradient.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/interpolator/interpolator.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/ensemble_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_domain_restart_variable.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_get_boundary.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/sat_vapor_pres/sat_vapor_pres.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memuse.c /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_reduce.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_save_restart.inc /project/CEFI-regional-MOM6/builds/../src/FMS/coupler/atmos_ocean_fluxes.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/constants/constants.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/include/fms_platform.h /project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov_inter.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_pset.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/fms_netcdf_unstructured_domain_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/fm_util.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_data.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_memutils.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters_compute_k.h /project/CEFI-regional-MOM6/builds/../src/FMS/amip_interp/amip_interp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_sum_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_axis.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/data_override/data_override.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_reduce.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_define.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_scatter.h /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_get_boundary.h /project/CEFI-regional-MOM6/builds/../src/FMS/exchange/stock_constants.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/axis_utils/axis_utils2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_alltoall_mpi.h /project/CEFI-regional-MOM6/builds/../src/FMS/field_manager/field_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_updateV.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_file_unit.inc /project/CEFI-regional-MOM6/builds/../src/FMS/diag_manager/diag_util.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_data.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/topography/gaussian_topog.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_write.h /project/CEFI-regional-MOM6/builds/../src/FMS/random_numbers/mersennetwister.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update_nonblock.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_file_unit.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_util.inc /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_bicubic.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_comm_mpi.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_global_field.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/mpp_efp.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/register_global_attribute.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_update_domains2D.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_domains_misc.inc /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/quicksort.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_get_field_size.inc /project/CEFI-regional-MOM6/builds/../src/FMS/drifters/drifters.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/netcdf_io.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_nocomm_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_transmit_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/mosaic_util.c /project/CEFI-regional-MOM6/builds/../src/FMS/time_interp/time_interp_external2.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_sum_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_conserve.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_type_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/parser/yaml_parser.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/fms2_io/include/get_data_type_string.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_write.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_misc.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/group_update_unpack.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_alltoall_nocomm.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_data_nocomm.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mosaic/create_xgrid.h /project/CEFI-regional-MOM6/builds/../src/FMS/fms/fms_io_unstructured_setup_one_field.inc /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_get_boundary_ad.h /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_read_2Ddecomp.h /project/CEFI-regional-MOM6/builds/../src/FMS/astronomy/astronomy.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_io_unstructured_read.inc /project/CEFI-regional-MOM6/builds/../src/FMS/horiz_interp/horiz_interp_type.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/time_manager/time_manager.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/monin_obukhov/monin_obukhov.F90 /project/CEFI-regional-MOM6/builds/../src/FMS/mpp/include/mpp_do_update.h
clean: neat
	-rm -f .libfms.a.cppdefs $(OBJ) libfms.a

neat:
	-rm -f $(TMPFILES)

localize: $(OFF)
	cp $(OFF) .

TAGS: $(SRC)
	etags $(SRC)

tags: $(SRC)
	ctags $(SRC)

libfms.a: $(OBJ)
	$(AR) $(ARFLAGS) libfms.a $(OBJ)

