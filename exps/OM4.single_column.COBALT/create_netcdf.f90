program create_netcdf
    use netcdf
    implicit none

    ! Variable declarations
    integer :: ncid, varid, dimids(3), status
    integer, parameter :: nx = 4, ny = 4, nz = 8
    real, dimension(nx, ny, nz) :: data
    integer :: i, j, k, counter

    ! File name
    character(len=256) :: filename
    filename = "output_4x4x8.nc"

    ! Initialize the data array with values from 1 to nx * ny * nz
    counter = 1
    do k = 1, nz
        do j = 1, ny
            do i = 1, nx
                data(i, j, k) = real(counter)
                counter = counter + 1
            end do
        end do
    end do

    ! Create the NetCDF file
    status = nf90_create(trim(filename), NF90_CLOBBER, ncid)
    if (status /= NF90_NOERR) then
        print *, "Error creating NetCDF file: ", trim(nf90_strerror(status))
        stop
    end if

    ! Define dimensions
    status = nf90_def_dim(ncid, "x", nx, dimids(1))
    if (status /= NF90_NOERR) then
        print *, "Error defining x dimension: ", trim(nf90_strerror(status))
        stop
    end if

    status = nf90_def_dim(ncid, "y", ny, dimids(2))
    if (status /= NF90_NOERR) then
        print *, "Error defining y dimension: ", trim(nf90_strerror(status))
        stop
    end if

    status = nf90_def_dim(ncid, "z", nz, dimids(3))
    if (status /= NF90_NOERR) then
        print *, "Error defining z dimension: ", trim(nf90_strerror(status))
        stop
    end if

    ! Define the variable
    status = nf90_def_var(ncid, "data", NF90_DOUBLE, dimids, varid)
    if (status /= NF90_NOERR) then
        print *, "Error defining variable: ", trim(nf90_strerror(status))
        stop
    end if

    ! End define mode
    status = nf90_enddef(ncid)
    if (status /= NF90_NOERR) then
        print *, "Error ending define mode: ", trim(nf90_strerror(status))
        stop
    end if

    ! Write the data to the file
    status = nf90_put_var(ncid, varid, data)
    if (status /= NF90_NOERR) then
        print *, "Error writing data: ", trim(nf90_strerror(status))
        stop
    end if

    ! Close the NetCDF file
    status = nf90_close(ncid)
    if (status /= NF90_NOERR) then
        print *, "Error closing NetCDF file: ", trim(nf90_strerror(status))
        stop
    end if

    print *, "NetCDF file created successfully: ", trim(filename)
end program create_netcdf