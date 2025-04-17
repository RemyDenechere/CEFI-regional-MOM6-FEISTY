module COBALT_IC_RESTART_public_var
    ! ====================================================================================!
    ! COBALT_IC_RESTART_public_var.f90
    !
    ! This module contains public variables and structures for the COBALT IC RESTART in 
    ! file COBALT_IC_RESTART.f90
    ! 
    ! ====================================================================================!
    implicit none

    ! Definition of parameters  ----------------------------------------------------------
    integer, parameter  :: dp = kind(0.d0)   ! double precision
    integer, parameter :: dim_4D = 52
    integer, parameter :: dim_3D = 19

    character(LEN=280), parameter ::root_dir = "/project/rdenechere/CEFI-regional-MOM6-FEISTY/exps/OM4.single_column.COBALT/",&
                                    root_dir_output = "/project/rdenechere/COBALT_output/COBALT_offline_forcing_files/",&
                                    output_file = "COBALT_2023_10_spinup_subset.nc",&
                                    dir_tracer_3D = "20040101.ocean_cobalt_btm.nc",&
                                    dir_tracer_4D = "20040101.ocean_cobalt_restart.nc"

    ! variable names from COBALT output: 
    character(LEN=15), dimension(dim_4D), parameter :: var_4D = ["alk            ",&
                                                            "cadet_arag     ",&
                                                            "cadet_calc     ",&
                                                            "dic            ",&
                                                            "fed            ",&
                                                            "fedet          ",&
                                                            "fedi           ",&
                                                            "felg           ",&
                                                            "femd           ",&
                                                            "fesm           ",&
                                                            "pdi            ",&
                                                            "plg            ",&
                                                            "pmd            ",&
                                                            "psm            ",&                                                
                                                            "ldon           ",&                                                
                                                            "ldop           ",&                                                
                                                            "lith           ",&                                                
                                                            "lithdet        ",&                                                
                                                            "nbact          ",&                                                
                                                            "ndet           ",&                                                
                                                            "ndi            ",&                                                
                                                            "nlg            ",&                                                
                                                            "nmd            ",&                                                
                                                            "nsm            ",&                                                
                                                            "nh4            ",&                                                
                                                            "no3            ",&                                                
                                                            "o2             ",&                                                
                                                            "po4            ",&                                                
                                                            "srdon          ",&                                                
                                                            "srdop          ",&                                                
                                                            "sldon          ",&                                                
                                                            "sldop          ",&                                                
                                                            "sidet          ",&                                                
                                                            "silg           ",&                                                
                                                            "simd           ",&                                                
                                                            "sio4           ",&                                                
                                                            "nsmz           ",&                                                
                                                            "nmdz           ",&                                                
                                                            "nlgz           ",&                                                
                                                            "cased          ",&                                                
                                                            "chl            ",&                                                
                                                            "co3_ion        ",&                                                
                                                            "htotal         ",&                                                
                                                            "irr_aclm       ",&                                                
                                                            "irr_aclm_sfc   ",&                                                
                                                            "irr_aclm_z     ",&                                                
                                                            "irr_mem_dp     ",&                                                
                                                            "mu_mem_ndi     ",&                                                
                                                            "mu_mem_nlg     ",&                                                
                                                            "mu_mem_nmd     ",&                                                
                                                            "mu_mem_nsm     ",&                                                
                                                            "nh3            " ]
    character(LEN=15), dimension(dim_3D), parameter :: var_3D = ["cadet_arag_btf " ,& !
                                                            "cadet_calc_btf ",&
                                                            "lithdet_btf    ",&
                                                            "ndet_btf       ",&
                                                            "pdet_btf       ",&
                                                            "sidet_btf      ",&
                                                            "fedet_btf      ",&
                                                            "nmd_btf        ",&
                                                            "nlg_btf        ",&
                                                            "ndi_btf        ",&
                                                            "femd_btf       ",&
                                                            "felg_btf       ",&
                                                            "fedi_btf       ",&
                                                            "psm_btf        ",&
                                                            "pmd_btf        ",&
                                                            "plg_btf        ",&
                                                            "pdi_btf        ",&
                                                            "simd_btf       ",&
                                                            "silg_btf       " ]
                                                            
    ! ====================================================================================!
    ! Public variables and structures
    ! ====================================================================================!
    type, public :: dimensions
        integer  :: Ntime, Nlayer, Nlath, Nlongh
        real(dp), dimension(:), allocatable :: time, layer
        real(dp), dimension(:,:), allocatable :: max_depth, lath, longh
    end type dimensions

    type(dimensions), public :: cobalt_output_dim
    character(LEN=280), public :: root_dir_output_loc, root_dir_loc, loc, tracer_longname, & 
                                 dir_Temp, dir_zt, dir_lat, dir_lon, dir_max_depth


end module COBALT_IC_RESTART_public_var