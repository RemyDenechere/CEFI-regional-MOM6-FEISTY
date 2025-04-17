! =====================================================================================!
!   COBALT_IC_RESTART.f90:
! 
!   Contact: REMY DENECHERE <rdenechere@ucsd.edu>
!
!   Description:
!   This program creates the Initial Condition (IC) for the COBALT model. It reads the
!   necessary data from the specified location and saves the IC for all BGC tracers in a 
!   NetCDF file called COBALT_2023_10_spinup_subset.nc.
!   COBALT_IC_RESTART_public_var.f90 contains the public variables and structures used in this program.
!   
!   Usage: 
!   > make 
!   > ./COBALT_IC_RESTART <location>
! =====================================================================================!
program COBALT_IC_RESTART
    use netcdf
    use COBALT_IC_RESTART_public_var

    implicit none
    
    ! Read the LOC variable from the command line: -----------------------------------
    CALL GET_COMMAND_ARGUMENT(1, loc)
    if (len_trim(loc) == 0) then
        print *, "Error: LOC argument is missing. Usage: ./program LOC"
        stop
    end if

    ! Define directories and files based on loc: -----------------------------------
    root_dir_output_loc = trim(root_dir_output) // trim(loc) // "/" // trim(loc) // "_offline_yr_1/"
    root_dir_loc = trim(root_dir) // trim(loc) // "/"
    dir_Temp = trim(root_dir_output_loc)    // "20040101.ocean_feisty_forcing.nc"
    dir_zt = trim(root_dir_output_loc)      // "20040101.ocean_feisty_forcing_detritus.nc"
    dir_lat = trim(root_dir_loc)            // "ocean_hgrid.nc"
    dir_lon = trim(root_dir_loc)            // "ocean_hgrid.nc"
    dir_max_depth = trim(root_dir_loc)      // "ocean_topog.nc"

    ! Define dimensions for COBALT output:
    CALL GET_DIMENSIONS(dir_Temp)

    ! Create IC for each BGC tracer:
    CALL COBALT_SAVE_IC()

    print*, "COBALT IC for all BGC tracers saved"

    

    contains
    ! ====================================================================================!
    !   GET_DIMENSIONS:
    !   This subroutine retrieves the dimensions of the of the 1D column simulation at the
    !   specified location.
    !   Dimension 1: Time (days)
    !   Dimension 2: Layer (m)
    !   Dimension 3: Latitude 
    !   Dimension 4: Longitude
    ! ====================================================================================!
    subroutine GET_DIMENSIONS(dir)
        character(LEN=280), intent(in) :: dir
        character(LEN=250) :: xname, yname, zname, hname
        integer  :: ncid, ierr
        integer, dimension(4) :: dim
        
        ! Open NetCDF: --------------------------------------------
        ierr = nf90_open(dir, NF90_NOWRITE, ncid)
        if (ierr /= NF90_NOERR) then
            print *, "Error opening file: ", trim(dir)
            STOP
        end if

        ! define the dimensions ids: ------------------------------------
        dim(1) = 4
        dim(2) = 3
        dim(3) = 2
        dim(4) = 1

        ! Inquire dimensions length:  ------------------------------------
        ierr = nf90_inquire_dimension(ncid, dim(1), xname, cobalt_output_dim%Ntime)
        ierr = nf90_inquire_dimension(ncid, dim(2), yname, cobalt_output_dim%Nlayer)
        ierr = nf90_inquire_dimension(ncid, dim(3), zname, cobalt_output_dim%Nlath)
        ierr = nf90_inquire_dimension(ncid, dim(4), hname, cobalt_output_dim%Nlongh)
        
        !Close netCDF file
        ierr = nf90_close(ncid)
        
        ! print outputs: -------------------------------------------
        print *, " "
        print *, "------------------------------------"
        print *, "COBALT dimensions: to create IC ", output_file
        print *, "1st dimension =", trim(xname), "; length = ", cobalt_output_dim%Ntime
        print *, "2nd dimension =", trim(yname), "; length = ", cobalt_output_dim%Nlayer
        print *, "3rd dimension =", trim(zname), "; length = ", cobalt_output_dim%Nlath
        print *, "4th dimension =", trim(hname), "; length = ", cobalt_output_dim%Nlongh
        print *, "------------------------------------" 

        ! Allocatate dimension values: ------------------------------------
        allocate(cobalt_output_dim%time(1)); cobalt_output_dim%time = 1.0_dp
        allocate(cobalt_output_dim%layer(cobalt_output_dim%Nlayer))
        allocate(cobalt_output_dim%lath(9,9))
        allocate(cobalt_output_dim%longh(9,9))
        allocate(cobalt_output_dim%max_depth(cobalt_output_dim%Nlongh, cobalt_output_dim%Nlath))

        ! Get values for each dimension: ------------------------------------
        CALL readgrid1D(dir_zt, "zl", cobalt_output_dim%layer)  ! pseudo layer depth 
        CALL readgrid2D(dir_lat, "y", cobalt_output_dim%lath) ! latitude 
        CALL readgrid2D(dir_lon, "x", cobalt_output_dim%longh) ! longitude
        CALL readgrid2D(dir_max_depth, "depth", cobalt_output_dim%max_depth) ! max depth   

        ! Interpolate depth 
        ! ! Print values for each dimension: ------------------------------------
        ! print *, " "
        ! print *, "------------------------------------"
        ! print *, "layer depth (m): ", cobalt_output_dim%layer
        ! print *, "latitude (degrees): ", cobalt_output_dim%lath
        ! print *, "longitude (degrees): ", cobalt_output_dim%longh
        ! print *, "max depth (m): ", cobalt_output_dim%max_depth
        ! print *, "------------------------------------"

    end subroutine GET_DIMENSIONS

    ! ====================================================================================!
    !   COBALT_SAVE_IC:
    !   This subroutine saves the Initial Condition (IC) for all BGC tracers in the COBALT
    !   model. It creates a NetCDF file and adds the tracer variables to it.
    !   The tracers have different dimensions: 3D and 4D and all have to reshape to 4D.
    !   The 3D tracers are reshaped to 4D with the first layer being the 3D tracer value.
    !   We use the last time step for the IC. time dimension is 1. 
    ! ====================================================================================!
    subroutine COBALT_SAVE_IC()
        integer(4) :: ncid, dimids(4)
        integer :: i
        real(dp), dimension(cobalt_output_dim%Nlongh, cobalt_output_dim%Nlath, 1) :: tracer_value_3D
        real(dp), dimension(cobalt_output_dim%Nlongh, cobalt_output_dim%Nlath, cobalt_output_dim%Nlayer, 1) :: tracer_value_4D
        character(LEN=280) :: long_name

        ! iNitialize the filename for the NetCDF file
        call init_tracer_nc(output_file, ncid, dimids)
        
        ! Add the 3D tracer variables to the NetCDF file
        do i = 1, dim_3D
            call readgrid3D(dir_tracer_3D, var_3D(i), tracer_value_3D, long_name)
            call add_tracer_nc_3D(ncid, dimids, var_3D(i), tracer_value_3D, long_name)
        end do
   
        ! Add the 4D tracer variables to the NetCDF file
        do i = 1, dim_4D
            call readgrid4D(dir_tracer_4D, var_4D(i), tracer_value_4D, long_name)
            call add_tracer_nc_4D(ncid, dimids, var_4D(i), tracer_value_4D, long_name)
        end do
    
        ! Close the NetCDF file
        call end_tracer_nc(ncid)
    end subroutine COBALT_SAVE_IC


    ! ====================================================================================!
    !   init_tracer_nc:
    !   This subroutine initializes the NetCDF file Initial Condition file output_file
    !   for the tracers. It creates the file, defines the dimensions, and sets up the
    !   variables and attributes.
    ! ====================================================================================!
    subroutine init_tracer_nc(filename, ncid, dimids)
        character(LEN = 280), intent(in)        :: filename 
        integer, intent(inout)                  :: ncid, dimids(4)
        integer :: status
        integer :: varid_time, varid_layer, varid_lath, varid_longh
        integer :: i
 
        print*, "Creating NetCDF file for tracers: ", filename

        ! Create the NetCDF file
        status = nf90_create(trim(filename), NF90_CLOBBER, ncid)
        if (status /= NF90_NOERR) then
            print *, "Error opening " , trim(filename), " in init_tracer_nc"
            print *, trim(nf90_strerror(status))
            STOP
        end if

        ! Define the dimensions
        status = nf90_def_dim(ncid, 'Time' , NF90_UNLIMITED,  dimids(4))
        if (status /= NF90_NOERR) then
            print *, trim(nf90_strerror(status))
            STOP
        end if
        status = nf90_def_dim(ncid, 'Layer', cobalt_output_dim%Nlayer, dimids(3))
        status = nf90_def_dim(ncid, 'lath' , cobalt_output_dim%Nlath , dimids(2))
        status = nf90_def_dim(ncid, 'lonh' , cobalt_output_dim%Nlongh, dimids(1))

        !! Define variables for each dimension: --------------------------------------------------------------
        ! Time: 
            ! Define the variable
            status = nf90_def_var(ncid, 'Time', NF90_doUBLE, dimids(4), varid_time)
            ! Add a attributes: 
            status = nf90_put_att(ncid, varid_time, 'long_name', 'Time')
            status = nf90_put_att(ncid, varid_time, 'Standard_name', 'time')
            status = nf90_put_att(ncid, varid_time, 'units', 'days')
            status = nf90_put_att(ncid, varid_time, 'calendar', 'proleptic_gregorian')
            status = nf90_put_att(ncid, varid_time, 'axis', "T")
            status = nf90_put_att(ncid, varid_time, '_FillValue', -9999.0_dp)

        ! Layer:
            ! Define the variable
            status = nf90_def_var(ncid, 'Layer', NF90_doUBLE, dimids(3), varid_layer)
            ! Add a attributes: 
            status = nf90_put_att(ncid, varid_layer, 'long_name', 'Layer')
            status = nf90_put_att(ncid, varid_layer, 'units', 'm')
            status = nf90_put_att(ncid, varid_layer, 'positive', 'down')
            status = nf90_put_att(ncid, varid_layer, 'axis', 'Z')
            status = nf90_put_att(ncid, varid_layer, 'cartesian_axis', 'Z')
            status = nf90_put_att(ncid, varid_layer, '_FillValue', -9999.0_dp)
        
        ! lath :
            ! Define the variable
            status = nf90_def_var(ncid, 'lath', NF90_doUBLE, dimids(2), varid_lath)    
            ! Add a attributes: 
            status = nf90_put_att(ncid, varid_lath, 'long_name', 'Latitude')
            status = nf90_put_att(ncid, varid_lath, 'Standard_name', 'latitude')
            status = nf90_put_att(ncid, varid_lath, 'units', 'degrees_north')
            status = nf90_put_att(ncid, varid_lath, 'axis', "Y")
            status = nf90_put_att(ncid, varid_lath, '_FillValue', -9999.0_dp)     
        
        ! lonh :
            ! Define the variable
            status = nf90_def_var(ncid, 'lonh', NF90_doUBLE, dimids(1), varid_longh)
            ! Add a attributes: 
            status = nf90_put_att(ncid, varid_longh, 'long_name', 'Longitude')
            status = nf90_put_att(ncid, varid_longh, 'Standard_name', 'longitude')
            status = nf90_put_att(ncid, varid_longh, 'units', 'degrees_east')
            status = nf90_put_att(ncid, varid_longh, 'axis', "X")
            status = nf90_put_att(ncid, varid_longh, '_FillValue', -9999.0_dp) 

        ! End the definitions mode: enter data mode
        status = nf90_enddef(ncid)

        ! Define valuse for each dimension : -----------------------------------------------------------
        status = nf90_put_var(ncid, varid_Time , 1)
        status = nf90_put_var(ncid, varid_layer, cobalt_output_dim%layer)
        status = nf90_put_var(ncid, varid_lath , cobalt_output_dim%lath(1, [2, 4, 6, 8]))
        status = nf90_put_var(ncid, varid_longh, cobalt_output_dim%longh([2,4,6,8], 1))
    end subroutine init_tracer_nc

    ! ====================================================================================!
    !   end_tracer_nc:
    !   This subroutine Close the NetCDF file Initial Condition file output_file
    !   after all tracers have been added. It closes the file and finalizes the definitions of the
    !   variables and attributes.
    ! ====================================================================================!
    subroutine end_tracer_nc(ncid)
        integer, intent(in) :: ncid
        integer :: status

        ! Close the file
        status = nf90_close(ncid)
        if (status /= NF90_NOERR) then
            print *, "Error clossing ncdf in end_tracer_nc"
            print *, trim(nf90_strerror(status))
            STOP
        end if
    end subroutine end_tracer_nc
    
    ! ====================================================================================!
    !   readgrid1D:
    !   This subroutine reads only one dimension from a variable named "varname" from a 
    !   NetCDF file in "dir" and stores it in the values array.
    ! ====================================================================================!
    subroutine readgrid1D(dir, varname, values)
        character(LEN=*), intent(in) :: dir, varname
        real(dp), dimension(:), intent(inout) :: values 
        integer :: ierr, ncid, varid
    
        ! Open NetCDF file
        ierr = nf90_open(dir, NF90_NOWRITE, ncid)
        if (ierr /= NF90_NOERR) then
            print *, nf90_strerror(ierr)
            print *, "Error opening file: ", trim(dir)
            stop
        end if
    
        ! Get variable ID
        ierr = nf90_inq_varid(ncid, varname, varid)
        if (ierr /= NF90_NOERR) then
            print *, "Error in ", trim(varname), " nf90_inquire_variable: ", nf90_strerror(ierr)
            stop
        end if
    
        ! Get values of the variable
        ierr = nf90_get_var(ncid, varid, values)
        if (ierr /= NF90_NOERR) then
            print *, "Error in ", trim(varname), " nf90_get_var: ", nf90_strerror(ierr)
            stop
        end if
    
        ! Close the NetCDF file
        ierr = nf90_close(ncid)
    end subroutine readgrid1D

    ! ====================================================================================!
    !   readgrid2D:
    !   This subroutine reads only two dimensions from a variable named "varname" from a 
    !   NetCDF file in "dir" and stores it in the values array.
    ! ====================================================================================!
    subroutine readgrid2D(dir, varname, values)
        character(LEN=*), intent(in) :: dir, varname
        real(dp), dimension(:,:), intent(inout) :: values
        integer :: ierr, ncid, varid
    
        ! Open NetCDF file
        ierr = nf90_open(dir, NF90_NOWRITE, ncid)
        if (ierr /= NF90_NOERR) then
            print *, nf90_strerror(ierr)
            print *, "Error opening file: ", trim(dir)
            stop
        end if
    
        ! Get variable ID
        ierr = nf90_inq_varid(ncid, varname, varid)
        if (ierr /= NF90_NOERR) then
            print *, "Error nf90_inquire_variable: ", nf90_strerror(ierr)
            stop
        end if
    
        ! Get values of the variable
        ierr = nf90_get_var(ncid, varid, values)
        if (ierr /= NF90_NOERR) then
            print *, "Error nf90_get_var: ", nf90_strerror(ierr)
            stop
        end if
    
        ! print *, "value from tracer ", trim(varname), " loaded"
    
        ! Close the NetCDF file
        ierr = nf90_close(ncid)
    end subroutine readgrid2D

     ! ====================================================================================!
    !   readgrid3D:
    !   This subroutine reads only three dimensions from a variable named "varname" from a 
    !   NetCDF file in "dir" and stores it in the values array.
    !   dimension read are time, lath and longh.
    !   We only extract the last time step for the IC.
    ! ====================================================================================!
    subroutine readgrid3D(dir, varname, values, long_name)
        character(LEN=*), intent(in) :: dir, varname
        real(dp), dimension(cobalt_output_dim%Nlongh, cobalt_output_dim%Nlath, 1), intent(inout) :: values
        character(LEN=*), intent(inout) :: long_name
        character(LEN=280) :: varname_source
        integer :: ierr, ncid, varid
        integer, dimension(3) :: start, count
        integer :: dimids(3), dimlen(3), i
        character(len=256) :: dimname   

        ! discrepeancy in the variable name between source and target files needs to be converted to extract 
        ! the correct variable name from the source file.
        varname_source = "f" // trim(varname(1:len_trim(varname)-3)) // "btm"

        ! Open NetCDF file
        ierr = nf90_open(dir, NF90_NOWRITE, ncid)
        if (ierr /= NF90_NOERR) then
            print *, nf90_strerror(ierr)
            print *, "Error opening file: ", trim(dir)
            stop
        end if

        ! Get variable ID
        ierr = nf90_inq_varid(ncid, varname_source, varid)
        if (ierr /= NF90_NOERR) then
            print *, "Error nf90_inquire_variable: ", varname_source, ": ", nf90_strerror(ierr)
            stop
        end if

         ! Get the long_name attribute of the variable
        ierr = nf90_get_att(ncid, varid, "long_name", long_name)
        if (ierr /= NF90_NOERR) then
            print *, "Error retrieving long_name for variable ", trim(varname_source), ": ", nf90_strerror(ierr)
            long_name = "Unknown"  ! Default value if long_name is not found
        else
            ! print *, "long_name for variable ", trim(varname_source), ": ", trim(long_name)
        end if

        ! Test dimensions in the netcdf file: ------------------------------------
        ! Get the variable's dimension IDs
        ierr = nf90_inquire_variable(ncid, varid, dimids=dimids)
        if (ierr /= NF90_NOERR) then
            print *, "Error inquiring variable dimensions: ", nf90_strerror(ierr)
            stop
        end if

        ! Loop through dimensions and print their lengths
        do i = 1, 3
            ierr = nf90_inquire_dimension(ncid, dimids(i), dimname, dimlen(i))
            if (ierr /= NF90_NOERR) then
                print *, "Error inquiring dimension: ", nf90_strerror(ierr)
                stop
            end if
            print *, "Dimension ", i, ": ", trim(dimname), " = ", dimlen(i)
        end do

        ! Define hyperslab to extract the last time step
        start = (/ 1, 1, cobalt_output_dim%Ntime -1 /)  ! Start at the last time step cobalt_output_dim%Ntime = 366
        count = (/cobalt_output_dim%Nlongh, cobalt_output_dim%Nlath, 1/) ! Read all 1 time and all long and lat dimensions
    
        ! Get values of the variable
        ierr = nf90_get_var(ncid, varid, values, start=start, count=count)
        if (ierr /= NF90_NOERR) then
            print *, "Error nf90_get_var ", trim(varname), ": ", nf90_strerror(ierr)
            stop
        end if
        
        print *, "Last time step ", trim(varname), " loaded; with long_name: ", trim(long_name)
        print *, trim(varname), ":"
        print *, values
    
        ! Close the NetCDF file
        ierr = nf90_close(ncid)
        Do i = 1, cobalt_output_dim%Nlath
            print *, "values for Long ", i, ": ", values(1:cobalt_output_dim%Nlongh, i, 1)
        end do

        ! STOP
    end subroutine readgrid3D
    

    ! ====================================================================================!
    !   add_tracer_nc_4D:
    !   This subroutine adds a 4D tracer variable to the NetCDF file.
    !   The tracer variable is reshaped from 3D to 4D before being added.
    ! =====================================================================================!
    subroutine add_tracer_nc_3D(ncid, dimids, varname, values, long_name)
        character(LEN=*), intent(in) :: varname
        character(LEN=*), intent(in) :: long_name
        integer, intent(in) :: dimids(4)
        integer, intent(in) :: ncid
        real(dp), dimension(cobalt_output_dim%Nlongh, cobalt_output_dim%Nlath, 1) :: values
        real(dp), dimension(cobalt_output_dim%Nlongh, cobalt_output_dim%Nlath, cobalt_output_dim%Nlayer, 1) :: var_4D
        integer :: varid, status
        integer :: j, k, l

        ! Transform 3D variable to 4D, values are injected in the first layer of the 4D variable:
        var_4D = 0.0_dp
        do k = 1, cobalt_output_dim%Nlath; do j = 1, cobalt_output_dim%Nlongh
                    var_4D(j, k, 1, 1) = values(j, k, 1)
        enddo; enddo
        
        print *, "Reshaped 3D variable to 4D: ", trim(varname), " with values: "
        print*,  var_4D
        ! Put opened netcdf into definition mode: 
        status = nf90_redef(ncid)

        ! Save a 4D variables 
        status = nf90_def_var(ncid, varname, NF90_doUBLE, dimids([1, 2, 3, 4]), varid)
        if (status /= NF90_NOERR) then
            print *, "Error Def FEISTY: ", trim(varname)
            print *, trim(nf90_strerror(status))
            STOP
        end if
        
        ! Add a attributes: 
        status = nf90_put_att(ncid, varid, "long_name", trim(long_name))
        status = nf90_put_att(ncid, varid, 'units', 'gWW m-2')
        status = nf90_put_att(ncid, varid, 'checksum', "               0")
        status = nf90_put_att(ncid, varid, '_FillValue', -9999.0_dp)

        ! End the definitions mode: enter data mode
        status = nf90_enddef(ncid)

        ! Write the variable data
        status = nf90_put_var(ncid, varid, var_4D)
        if (status /= NF90_NOERR) then
            print *, "Error in nf90_put_var: " , trim(varname), " in add_tracer_nc "
            print *, trim(nf90_strerror(status))
            STOP
        end if 

        print*, "Tracer ", trim(varname), " added to NetCDF file: ", output_file
    end subroutine add_tracer_nc_3D

    ! ====================================================================================!
    !   readgrid4D:
    !   This subroutine reads only four dimensions from a variable named "varname" from a 
    !   NetCDF file in "dir" and stores it in the values array.
    !   dimension read are time, layer, lath and longh.
    !   We only extract the last time step for the IC.
    ! ====================================================================================!
    subroutine readgrid4D(dir, varname, values, long_name)
        character(LEN=*), intent(in) :: dir, varname
        real(dp), dimension(cobalt_output_dim%Nlongh, cobalt_output_dim%Nlath, cobalt_output_dim%Nlayer, 1) :: values !
        character(LEN=*), intent(inout) :: long_name
        integer :: ierr, ncid, varid
        integer, dimension(4) :: start, count
        integer :: dimids(4), dimlen(4), i
        character(len=256) :: dimname   

        print*, "Reading 4D variable: ", trim(varname)
    
        ! Open NetCDF file
        ierr = nf90_open(dir, NF90_NOWRITE, ncid)
        if (ierr /= NF90_NOERR) then
            print *, nf90_strerror(ierr)
            print *, "Error opening file: ", trim(dir)
            stop
        end if

        ! Get variable ID
        ierr = nf90_inq_varid(ncid, varname, varid)
        if (ierr /= NF90_NOERR) then
            print *, "Error nf90_inquire_variable: ", varname, ": ", nf90_strerror(ierr)
            stop
        end if

         ! Get the long_name attribute of the variable
        ierr = nf90_get_att(ncid, varid, "long_name", long_name)
        if (ierr /= NF90_NOERR) then
            print *, "Error retrieving long_name for variable ", trim(varname), ": ", nf90_strerror(ierr)
            long_name = "Unknown"  ! Default value if long_name is not found
        else
            print *, "long_name for variable ", trim(varname), ": ", trim(long_name)
        end if

        ! Test dimensions in the netcdf file: ------------------------------------
        ! Get the variable's dimension IDs
        ierr = nf90_inquire_variable(ncid, varid, dimids=dimids)
        if (ierr /= NF90_NOERR) then
            print *, "Error inquiring variable dimensions: ", nf90_strerror(ierr)
            stop
        end if

        ! Loop through dimensions and print their lengths
        do i = 1, 4
            ierr = nf90_inquire_dimension(ncid, dimids(i), dimname, dimlen(i))
            if (ierr /= NF90_NOERR) then
                print *, "Error inquiring dimension: ", nf90_strerror(ierr)
                stop
            end if
            print *, "Dimension ", i, ": ", trim(dimname), " = ", dimlen(i)
        end do

        ! Define hyperslab to extract the last time step
        start = (/ 1, 1, 1, cobalt_output_dim%Ntime -1 /)  ! Start at the last time step cobalt_output_dim%Ntime = 366
        count = (/cobalt_output_dim%Nlongh, cobalt_output_dim%Nlath, cobalt_output_dim%Nlayer, 1 /) ! Read all 1 time and all long and lat dimensions
    
        ! Get values of the variable
        ierr = nf90_get_var(ncid, varid, values, start=start, count=count)
        if (ierr /= NF90_NOERR) then
            print *, "Error nf90_get_var ", trim(varname), ": ", nf90_strerror(ierr)
            stop
        end if
        
        print *, "Last time step ", trim(varname), " loaded; with long_name: ", trim(long_name)
        ! print *, trim(varname), ":"
        ! print *, values
    
        ! Close the NetCDF file
        ierr = nf90_close(ncid)
    end subroutine readgrid4D

    ! ====================================================================================!
    !   add_tracer_nc_4D:
    !   This subroutine adds a 4D tracer variable to the NetCDF file.
    ! =====================================================================================!
    subroutine add_tracer_nc_4D(ncid, dimids, varname, values, long_name)
        character(LEN=*), intent(in) :: varname
        character(LEN=*), intent(in) :: long_name
        integer, intent(in) :: dimids(4)
        integer, intent(in) :: ncid
        real(dp), dimension(cobalt_output_dim%Nlongh, cobalt_output_dim%Nlath, cobalt_output_dim%Nlayer, 1) :: values !var_reshaped
        integer :: varid, status
        integer :: j, k, l
        
        ! Put opened netcdf into definition mode: 
        status = nf90_redef(ncid)

        ! Save a 4D variables 
        status = nf90_def_var(ncid, varname, NF90_doUBLE, dimids([1, 2, 3, 4]), varid)
        if (status /= NF90_NOERR) then
            print *, "Error Def FEISTY: ", trim(varname)
            print *, trim(nf90_strerror(status))
            STOP
        end if
        
        ! Add a attributes: 
        status = nf90_put_att(ncid, varid, "long_name", trim(long_name))
        status = nf90_put_att(ncid, varid, 'units', 'gWW m-2')
        status = nf90_put_att(ncid, varid, 'checksum', "               0")
        status = nf90_put_att(ncid, varid, '_FillValue', -9999.0_dp)

        ! End the definitions mode: enter data mode
        status = nf90_enddef(ncid)

        ! Write the variable data
        status = nf90_put_var(ncid, varid,  values)
        if (status /= NF90_NOERR) then
            print *, "Error in nf90_put_var: " , trim(varname), " in add_tracer_nc_4D "
            print *, trim(nf90_strerror(status))
            STOP
        end if 

        print*, "Tracer ", trim(varname), " added to NetCDF file: ", output_file
    end subroutine add_tracer_nc_4D

end program COBALT_IC_RESTART