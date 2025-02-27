!<CONTACT EMAIL="rdenechere@ucsd.edu"> Rémy Denéchère
!</CONTACT>
!
!<OVERVIEW>
!  Coupling COBALT and FEISTY setup_basic_2 (Petrik et al., 2019)
!</OVERVIEW>
! 
!<DESCRIPTION>
! Calculate the high trophic level biomass (fish), benthic invertebrate biomass, and 
! predation on mesozooplankton, from the FEISTY framewok developped by C. Petrik et al., 2019
!
!   Add a prognostic tracer (tracer to pass over time): 
!   1) Define tracer as a field in FEISTY_type :        FEISTY%varname
!   2) Add the tracer in the list of tracers in subroutine user_add_tracer, call g_add_tracers
!
!</DESCRIPTION>

module generic_FEISTY

    use field_manager_mod,  only: fm_string_len, fm_path_name_len, fm_field_name_len
    use mpp_mod,            only: input_nml_file, mpp_error, stdlog, NOTE, WARNING, FATAL, stdout, mpp_chksum
    use time_manager_mod,   only: time_type, day_of_year
    use g_tracer_utils,     only: g_tracer_type, g_tracer_start_param_list, g_tracer_end_param_list
    use g_tracer_utils,     only: g_tracer_add, g_tracer_add_param, g_tracer_set_files
    use g_tracer_utils,     only: g_tracer_set_values, g_tracer_get_pointer
    use g_tracer_utils,     only: g_tracer_get_common, g_tracer_get_values
    use g_tracer_utils,     only: register_diag_field=>g_register_diag_field
    use g_tracer_utils,     only: g_send_data
    use g_tracer_utils,     only: g_diag_type, g_diag_field_add
    use fms_mod,            only: check_nml_error

    use fm_util_mod,        only: fm_util_start_namelist, fm_util_end_namelist
    use fms_mod,            only: open_namelist_file, close_file

implicit none; private  

character(len=128) :: version = '$FEISTY_setupbasic2$'
character(len=128) :: tag = '$Name: XX$'
character(len=fm_string_len), parameter :: mod_name       = 'generic_FEISTY'
character(len=fm_string_len), parameter :: package_name   = 'generic_feisty'


! public might not be necessary as everything will be called inside Generic Cobalt,
! consider using "use generic_FEISTY" in generic_COBALT.F90: 
public generic_FEISTY_register
public generic_FEISTY_init
public generic_FEISTY_register_diag
public generic_FEISTY_tracer_get_values
public generic_FEISTY_tracer_get_pointer
public generic_FEISTY_update_from_coupler
public generic_FEISTY_fish_update_from_source
public generic_FEISTY_end
public generic_FEISTY_update_pointer
public generic_FEISTY_send_diagnostic_data

!#########################################################################################!  
!                                       FEISTY namelist 
logical :: FunctRspons_typeIII = .false.
logical :: do_print_FEISTY_diagnostic = .false.
real    :: a_enc = 70.0
real    :: dp_int = 100.0
real    :: k_fct_tp = 1.0
real    :: k50 = 1.0

namelist /generic_FEISTY_nml/ do_print_FEISTY_diagnostic, FunctRspons_typeIII, a_enc, dp_int, k_fct_tp, k50


!#########################################################################################!  
!                        Definition of the types used for FEISTY

!------------------------------------
! Structure type of a single fish with 
! all its physiological parameters.  
!-----------------------------------
type, public :: fish_type
	! -----------------------------------
	! Non Diagnostics variables
	! -----------------------------------
    real :: B                   ! Biomass 
    real :: w = 0               ! weight
    real :: Tcorr_e = 0         ! temperature correction for Encounter and Cmax
    real :: Tcorr_met = 0       ! temperature correction for metabolism
    real :: V_w = 0             ! Size-dependent searching rate
    real :: V = 0               ! Searching rate after temperature correction
    real :: cmax_w = 0          ! Size-based Maximum consumption rate 
    real :: cmax = 0            ! Maximum consumption rate after temperature correction 
    real :: met_w = 0           ! Size-based metabolic cost 
    real :: mu_f = 0            ! Fishing mortality 
    real :: mu_a = 0            ! natural mortality
    real :: mu 
 
    ! consumption for each prey : --------------
    real :: cons_Sf = 0            ! --
    real :: cons_Sp = 0            ! --
    real :: cons_Sd = 0            ! --
    real :: cons_Mf = 0            ! --
    real :: cons_Mp = 0            ! --
    real :: cons_Md = 0            ! --
    real :: cons_Lp = 0            ! --
    real :: cons_Ld = 0            ! --
    
    ! Feeding level for each prey : -------------
    real :: f_Mz = 0            ! --       
    real :: f_Lz = 0            ! --         
    real :: f_Sf = 0            ! --
    real :: f_Sp = 0            ! --
    real :: f_Sd = 0            ! --
    real :: f_Mf = 0            ! --
    real :: f_Mp = 0            ! --
    real :: f_Md = 0            ! --
    real :: f_Lp = 0            ! --
    real :: f_Ld = 0            ! --
    real :: f_BE = 0            ! --

    ! -----------------------------------
	! Diagnostics variables of fish 
    ! These diagnostic variables are not tracers, i.e., they 
    ! do not need to be passed from a time step to the next one
	! -----------------------------------
	real, allocatable, dimension(:,:) :: &
    	met, & 		    !    Metabolic rate
    	
        enc_Mz, & 	    !    Encounter rate of medium zooplankton
    	enc_Lz, & 	    !    Encounter rate of large zooplankton
    	enc_f, & 	    !    Encounter rate of forage fish
    	enc_p, & 	    !    Encounter rate of pelagic fish
    	enc_d, & 	    !    Encounter rate of demersal fish
    	enc_BE, & 	    !    Encounter rate of benthos

    	cons_Mz, & 	    !    Consumption rate of medium zooplankton
    	cons_Lz, & 	    !    Consumption rate of large zooplankton
    	cons_f, & 	    !    Consumption rate of forage fish
    	cons_p, & 	    !    Consumption rate of large pelagic fish
    	cons_d, & 	    !    Consumption rate of demersal fish
    	cons_BE, & 	    !    Consumption rate of benthos
    	cons_tot, & 	!    Total Consumption rate 

    	f_tot, & 	    !    Feeding level = Tot_con / Cmax
    	mu_p, & 	    !    Predation mortality rate
    	E_A, & 		    !    Rate of biomass accumulation/ Available energy
    	prod, & 	    !    Productivity = E_A* Biomass
    	Fout, & 	    !    flux of biomass to next size class
    	rho, & 		    !    rho
    	yield, &        !    Yield = nu_F * Biomass 

        dBdt_fish       !    Derivative for fish in m-2 d-1 
	
    
    ! Then each diagnostic gets an id
    integer ::		    &
        id_met          = -1, &
 
        id_enc_Mz       = -1, &
        id_enc_Lz       = -1, &
        id_enc_f        = -1, &
        id_enc_p        = -1, &
        id_enc_d        = -1, &
        id_enc_BE       = -1, &
    
        id_cons_Mz      = -1, &
        id_cons_Lz      = -1, &
        id_cons_f       = -1, &
        id_cons_p       = -1, &
        id_cons_d       = -1, &
        id_cons_BE      = -1, &
        id_cons_tot     = -1, &
    
        id_f_tot        = -1, &
        id_mu_p         = -1, &
        id_E_A          = -1, &
        id_prod         = -1, &
        id_Fout         = -1, &
        id_rho          = -1, &
        id_yield        = -1
end type fish_type


!------------------------------------
! Structure type of the FEISTY
! containing all the fish functinal group and their structure 
! and the environemental variables.   
!-----------------------------------
type, public :: FEISTY_type
    character(len=fm_string_len)               :: name           = '_'
    character(len=fm_field_name_len)           :: suffix         = ' '
    character(len=fm_field_name_len)           :: long_suffix    = ' '
    character(len=fm_string_len)               :: version
                
    ! Biomass of the resource: 
    real :: Mz = 0
    real :: Lz = 0
    real :: BE = 0

    ! Environemental variable: 
    ! real :: zfm = 0                  ! Fraction of zooplankton mortality loss consumed
    ! real :: zfl = 0                  ! Fraction of zooplankton mortality loss consumed  
    real :: T = 0                    ! Temperature at the specific layer
    real :: det = 0                  ! Detritus flux to benthic community
    ! real :: H = 20000.0              ! Depth (set up deeper than max depth to avoid problem with demersal tdiff if depth is not setup from environemental data)
	
    ! FEISTY parameters: -----------------------------------------
    ! Groupe information: ---------------------------------------------
    integer :: nFishGroup                      ! Number of fish functional group
    integer :: nBenthos                        ! Number of Benthic resource  
    integer :: nMesoZoo                        ! Number of Mesozooplankton
    integer :: nDeriv                          ! Number of group for witch the derivative is calculated    

    real :: zero                ! Zero
    real :: eps                 ! Small number for divisions 
    real :: d2s                 ! conversion second to day
    real :: y2d                 ! conversion day to year 
    real :: IC                  ! Initial Conditions 
    real :: conv_m2_to_m2       ! conversion from m2 to m2 searching rates! 


    ! Parameters physiology: ------------------------------------------
    real :: ke              ! [°c-1]                Temperature correction for cmax and encounter
    real :: kmet            ! [°c-1]                Temperature correction for Metabolic cost cost
    real :: k_fct_tp
    real :: a_enc           ! []                    Coeff for mass-specific Encounter rate             
    real :: b_enc           ! [m-2 g^(b_enc−1) d−1] Exponent for mass-specific Encounter rate 
    real :: a_cmax          ! [d g^(b_cmax)]        Coeff for Cmax 
    real :: b_cmax          ! []                    Exponent for Cmax 
    real :: a_met           ! [d-1 g^(b_met)]       Coeff for Metabolic loss 
    real :: b_met           ! []                    Exponent for Metabolic cost 
    real :: alpha           ! []                    Assimilation efficiency 
    real :: Nat_mrt         ! [m-2 d-1]             Natural mortality coeffient 
    ! Fishing : ---------------------------------------------------------
    real :: Frate           ! [d-1]                 Fishing intensity 
    real :: Jselct          ! []                    Fishing Selectivity of juveniles  
    real :: Aselct          ! []                    Fishing Selectivity of adult 

    ! Param for Size-class growth rate: ----------------------------------
    real :: Z_s             ! Small fish Ratio of upper and lower body size boundary 
    real :: Z_m             ! Medium fish Ratio of upper and lower body size boundary 
    real :: Z_l             ! Large fish Ratio of upper and lower body size boundary 
    real :: kappa_l         ! Larval Fraction of energy available (E_a) invested in growth 
    real :: kappa_j         ! Juvenile Fraction of energy available (E_a) invested in growth 
    real :: kappa_a         ! Adult Fraction of energy available (E_a) invested in growth 
    real :: eps_R           ! Reproduction efficiency: account for energy spend in reprodutive organe, aditional foraging activities, cost of migration, and death from egg release to hatchement. 
    ! Benthic chemostat
    real :: beta            ! Benthic Efficiency from detritus to benthic biomass
    real :: CC              ! Carring Capacity for benthic chemostat

    ! Parameters feeding preferences: ---------------------------------
    real :: Sm                      ! Medium size feeding on Medium Zoo
    real :: D                       ! Demersal feeding in pelagic reduction
    real :: A                       ! Adult predation reduction
    real :: pref_Mz                 ! Preference Small fish for medium mesozooplankton group
    ! Medium Forage 
    real :: pref_Mf_Mz              ! Preference for Medium Mesozooplankton   
    real :: pref_Mf_Lz              ! Preference for Large Mesozooplankton
    real :: pref_Mf_S               ! Preference for small fish
    ! Medium pelagic 
    real :: pref_Mp_Mz              ! Preference for Medium Mesozooplankton
    real :: pref_Mp_Lz              ! Preference for Large Mesozooplankton
    real :: pref_Mp_S               ! Preference for small fish
    ! Medium Demersal 
    real :: pref_Md_BE              ! Preference for Benthos
    ! Large Pelagic
    real :: pref_Lp_Mf              ! Preference for Medium forage
    real :: pref_Lp_Mp
    ! Large Demersal
    real :: pref_Ld_Mf              ! Preference for Medium forage
    real :: pref_Ld_Mp              ! Preference for Medium pelagics
    real :: pref_Ld_Md              ! Preference for Medium Demersal
    real :: pref_Ld_BE              ! Preference for Benthos

    real :: Bent_eff

    ! Conversion from cobalt zooplankton and detritus to FEISTY  
    real :: convers_Mz              ! zooplankton biomass 
    real :: convers_det             ! detritus 
    real :: PI_be_cutoff            ! seafloor depth value for demersal time in pelagic cutoff

	
    ! Tracers: variables that need to be passed from on time step to the next: 
    real, dimension(:,:), allocatable ::Sf_B,  &
                                        Sp_B,  &
                                        Sd_B,  &
                                        Mf_B,  &
                                        Mp_B,  &
                                        Md_B,  &
                                        Lp_B,  &
                                        Ld_B,  &
                                        BE_B,  &
                                        dBdt_BE          ! Not a tracer
    ! 
    integer ::  id_Sf_B = -1,       &
                id_Sp_B = -1,       &
                id_Sd_B = -1,       &
                id_Mf_B = -1,       &
                id_Mp_B = -1,       &
                id_Md_B = -1,       &
                id_Lp_B = -1,       &
                id_Ld_B = -1,       &
                id_BE_B = -1

    ! pointers of the tracers: 
    real, dimension(:,:,:), pointer ::  p_Sf_B,  &
                                        p_Sp_B,  &
                                        p_Sd_B,  &
                                        p_Mf_B,  &
                                        p_Mp_B,  &
                                        p_Md_B,  &
                                        p_Lp_B,  &
                                        p_Ld_B,  &
                                        p_BE_B
    
    real, dimension(8, 11) :: Pref_mat, Resource_mat, Resource_Pref

end type FEISTY_type


!-----------------------------------
! An auxiliary type for storing varible names
!-----------------------------------
type, public :: vardesc
   character(len=fm_string_len) :: name     ! The variable name in a NetCDF file.
   character(len=fm_string_len) :: longname ! The long name of that variable.
   character(len=1)  :: hor_grid ! The hor. grid:  u, v, h, q, or 1.
   character(len=1)  :: z_grid   ! The vert. grid:  L, i, or 1.
   character(len=1)  :: t_grid   ! The time description: s, a, m, or 1.
   character(len=fm_string_len) :: units    ! The dimensions of the variable.
   character(len=1)  :: mem_size ! The size in memory: d or f.
end type vardesc


! Indexes for fish type: 
integer, parameter ::   SF = 1, &               ! Small Forage
                        SP = 2, &               ! Small Pelagic           
                        SD = 3, &               ! Small Demersal
                        MF = 4, &               ! Medium Forage
                        MP = 5, &               ! Medium Pelagic
                        MD = 6, &               ! Medium Demersal
                        LP = 7, &               ! Large Pelagic
                        LD = 8                  ! large Demersal

! Indexes of zooplankton in prey vector from COBALT:
integer, parameter ::   idx_Mz = 7, &           ! Medium zooplankton
                        idx_Lz = 8              ! Large zooplankton 

logical, parameter :: do_Benthic_pred_detritus = .false. ! Do predation from benthic resource on detritus flux! 

! Define the fish and FEISTY variables from types
integer, parameter :: NUM_FISH = 8
type(fish_type), dimension(NUM_FISH) :: fish
type(FEISTY_type) :: FEISTY
	
contains

subroutine generic_FEISTY_register(tracer_list)    
    type(g_tracer_type), pointer, intent(inout) :: tracer_list
    integer                                     :: ioun
    integer                                     :: ierr
    integer                                     :: io_status

    !-----------------------------------------------------------------------
    ! Error: 
    !-----------------------------------------------------------------------
    character(len=fm_string_len), parameter :: sub_name = 'generic_FEISTY_register'
    character(len=256), parameter   :: error_header =                               &
        '==>Error from ' // trim(mod_name) // '(' // trim(sub_name) // '): '
    character(len=256), parameter   :: warn_header =                                &
        '==>Warning from ' // trim(mod_name) // '(' // trim(sub_name) // '): '
    character(len=256), parameter   :: note_header =                                &
        '==>Note from ' // trim(mod_name) // '(' // trim(sub_name) // '): '

    ! Test adding a namelist override for FEISTY 
    ioun = open_namelist_file()
    read  (ioun, generic_FEISTY_nml,iostat=io_status)
    ierr = check_nml_error(io_status,'generic_FEISTY_nml')
    call close_file (ioun)

    ! Specify all prognostic and diagnostic tracers of this modules.
    call user_add_tracers_FEISTY(tracer_list)

end subroutine generic_FEISTY_register



!  <SUBROUTINE NAME="generic_FEISTY_init">
!  <OVERVIEW>
!   Initialize the generic FEISTY module
!  </OVERVIEW>
!  <DESCRIPTION>
!   This subroutine:
!       Adds all the FEISTY Tracers to the list of generic Tracers
!       passed to it via utility subroutine g_tracer_add().
!
!       Adds all the parameters used by this module via utility
!       subroutine g_tracer_add_param().
!
!       Allocates all work arrays used in the module.
!  </DESCRIPTION>
!  <TEMPLATE>
!   call generic_FEISTY_init(tracer_list)
!  </TEMPLATE>
!  <IN NAME="tracer_list" TYPE="type(g_tracer_type), pointer">
!   Pointer to the head of generic tracer list.
!  </IN>
! </SUBROUTINE>
subroutine generic_FEISTY_init(tracer_list)
    type(g_tracer_type), pointer :: tracer_list
    integer :: m
    character(len=fm_string_len), parameter :: sub_name = 'generic_FEISTY_init'

    !Specify and initialize all parameters used by this package
    call user_add_params_FEISTY

    !Allocate all the private work arrays used by this module.
    call user_allocate_arrays_FEISTY

    ! To check : 
    ! -------------------------------------------------------------------------------
    ! calculation below are size-based clearance rate and cmax, the correction for temperature is made in
    ! generic_FEISTY_update_from_source 
    ! parameters used : 
    ! w        : wet weight                                 [g]
    ! a_enc    : coefficient for Encounter rate             [m2 g^(b_enc−1) d−1]
    ! b_enc    : exponent for clearance rate                [Ø]
    ! a_cmax   : coefficient for maximum consumption        [d-1 g^(b_cmax)]
    ! b_cmax   : exponent for maximum consumption           [Ø]
    ! -------------------------------------------------------------------------------

    ! Add initialisation of constant parameters for fish: 
    ! Individual Mass (g) geometric mean for each group 
    fish(1)%w = 10.0**((log10(0.001)+log10(0.5))/2) 
    fish(2)%w = 10.0**((log10(0.001)+log10(0.5))/2)
    fish(3)%w = 10.0**((log10(0.001)+log10(0.5))/2)
    fish(4)%w = 10.0**((log10(0.5)+log10(250.0))/2) 
    fish(5)%w = 10.0**((log10(0.5)+log10(250.0))/2) 
    fish(6)%w = 10.0**((log10(0.5)+log10(250.0))/2) 
    fish(7)%w = 10.0**((log10(250.0)+log10(125000.0))/2)
    fish(8)%w = 10.0**((log10(250.0)+log10(125000.0))/2)

    ! Size-based calculation : -------------------------------------------------------
    do m = 1, FEISTY%nFishGroup
        fish(m)%V_w = FEISTY%a_enc * fish(m)%w ** (-FEISTY%b_enc)/ FEISTY%y2d       ! Calcul of size-based clearance rate
        fish(m)%cmax_w = FEISTY%a_cmax * fish(m)%w **(-FEISTY%b_cmax)/FEISTY%y2d    ! Calcul of size-based Cmax 
        fish(m)%mu_a = FEISTY%Nat_mrt                                               ! Calcul of size-based Natural mortality 
        fish(m)%met_w = FEISTY%a_met * fish(m)%w ** (-FEISTY%b_met)/FEISTY%y2d      ! Calcul of size-based metabolic cost
    end do    

    ! Matrix of preferences:
    ! Resource:                             Medium Zoo         Large Zoo          Benthic            Small Forage        Small Pelagic       Small Demersal      Med Forage          Med Pel             Med Demersl         LP   LD     ! Predators: 
    FEISTY%Pref_mat = transpose(reshape([   FEISTY%pref_Mz,    0.0,               0.0,               0.0,                0.0,                0.0,                0.0,                0.0,                0.0,                0.0, 0.0, & ! Small Forage
                                            FEISTY%pref_Mz,    0.0,               0.0,               0.0,                0.0,                0.0,                0.0,                0.0,                0.0,                0.0, 0.0, & ! Small Pelagic
                                            FEISTY%pref_Mz,    0.0,               0.0,               0.0,                0.0,                0.0,                0.0,                0.0,                0.0,                0.0, 0.0, & ! Small Demersal
                                            FEISTY%pref_Mf_Mz, FEISTY%pref_Mf_Lz, 0.0,               FEISTY%pref_Mf_S,   FEISTY%pref_Mf_S,   FEISTY%pref_Mf_S,   0.0,                0.0,                0.0,                0.0, 0.0, & ! Medium Forage
                                            FEISTY%pref_Mp_Mz, FEISTY%pref_Mp_Lz, 0.0,               FEISTY%pref_Mp_S,   FEISTY%pref_Mp_S,   FEISTY%pref_Mp_S,   0.0,                0.0,                0.0,                0.0, 0.0, & ! Medium Pelagic
                                            0.0,               0.0,               FEISTY%pref_Md_BE, 0.0,                0.0,                0.0,                0.0,                0.0,                0.0,                0.0, 0.0, & ! Medium Demersal
                                            0.0,               0.0,               0.0,               0.0,                0.0,                0.0,                FEISTY%pref_Lp_Mf,  FEISTY%pref_Lp_Mp,  0.0,                0.0, 0.0, & ! Large Pelagic
                                            0.0,               0.0,               FEISTY%pref_Ld_BE, 0.0,                0.0,                0.0,                FEISTY%pref_Ld_Mf,  FEISTY%pref_Ld_Mp,  FEISTY%pref_Ld_Md,  0.0, 0.0  & ! Large Demersal 
                                            ], [11, 8]))

end subroutine generic_FEISTY_init



! <SUBROUTINE NAME="generic_FEISTY_register_diag">
! <DESCRIPTION>
!     Register diagnostic fields to be used in this module.
!     Note that the tracer fields are automatically registered in user_add_tracers_FEISTY
!     called in generic_FEISTY_register
!     User adds only diagnostics for fields that are not a member of g_tracer_type
! <DESCRIPTION>
! </SUBROUTINE>
subroutine generic_FEISTY_register_diag(diag_list)
    type(g_diag_type), pointer :: diag_list
    type(vardesc)  :: vardesc_temp
    integer        :: isc,iec,jsc,jec,isd,ied,jsd,jed,nk,ntau, axes(3), axesTi(3)
    type(time_type):: init_time
    real :: missing_value1 = -1.0e+10

    ! FEISTY might not need isc t0 nk 
    call g_tracer_get_common(isc, iec, jsc, jec, isd, ied, jsd, jed, nk, ntau, axes=axes, init_time=init_time)
    ! The following vardesc types contain a package of metadata about each tracer,
    ! including, in order, the following elements: name; longname; horizontal
    ! staggering ('h') for collocation with thickness points ; vertical staggering
    ! ('L') for a layer variable ; temporal staggering ('s' for snapshot) ; units ;
    ! and precision in non-restart output files ('f' for 32-bit float or 'd' for
    ! 64-bit doubles). For most tracers, only the name, longname and units should
    ! be changed.

    ! axes(1:D) with D the dimension of the variable 
    ! fish rates are in m-2 as they occurs at each layer (original FEISTY has them in m-2)

    !
    ! Register the diagnostics for the various fish type: ---------------------------------------
    !
    ! Register Metabolism (met):
        !
        ! SF: 
        vardesc_temp = vardesc("Sf_met","Metabolic losses of small forage fish",'h','1','s','d-1','f')
        fish(SF)%id_met = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname, vardesc_temp%units, missing_value = missing_value1)
        ! SP: 
        vardesc_temp = vardesc("Sp_met","Metabolic losses of small pelagic fish",'h','1','s','d-1','f')
        fish(SP)%id_met = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD: 
        vardesc_temp = vardesc("Sd_met","Metabolic losses of small demersal fish",'h','1','s','d-1','f')
        fish(SD)%id_met = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF: 
        vardesc_temp = vardesc("Mf_met","Metabolic losses of medium forage fish",'h','1','s','d-1','f')
        fish(MF)%id_met = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP: 
        vardesc_temp = vardesc("Mp_met","Metabolic losses of medium pelagic fish",'h','1','s','d-1','f')
        fish(MP)%id_met = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD: 
        vardesc_temp = vardesc("Md_met","Metabolic losses of medium demersal fish",'h','1','s','d-1','f')
        fish(MD)%id_met = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP: 
        vardesc_temp = vardesc("Lp_met","Metabolic losses of large pelagic fish",'h','1','s','d-1','f')
        fish(LP)%id_met = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD: 
        vardesc_temp = vardesc("Ld_met","Metabolic losses of large demersal fish",'h','1','s','d-1','f')
        fish(LD)%id_met = register_diag_field(package_name, vardesc_temp%name, axes(1:2), &
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
    

    ! Register Encounter rate of medium zooplankton (enc_Mz):
        ! SF:
        vardesc_temp = vardesc("SF_enc_Mz","Encounter rate of medium zooplankton for Small Forage",'h','1','s','m2 g-1 d-1','f')
        fish(SF)%id_enc_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_enc_Mz","Encounter rate of medium zooplankton for Small Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(SP)%id_enc_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_enc_Mz","Encounter rate of medium zooplankton for Small Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(SD)%id_enc_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_enc_Mz","Encounter rate of medium zooplankton for Medium Forage",'h','1','s','m2 g-1 d-1','f')
        fish(MF)%id_enc_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_enc_Mz","Encounter rate of medium zooplankton for Medium Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(MP)%id_enc_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_enc_Mz","Encounter rate of medium zooplankton for Medium Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(MD)%id_enc_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_enc_Mz","Encounter rate of medium zooplankton for Large Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(LP)%id_enc_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_enc_Mz","Encounter rate of medium zooplankton for Large Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(LD)%id_enc_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

    ! Register Encounter rate of large zooplankton (enc_Lz):
        ! SF:
        vardesc_temp = vardesc("SF_enc_Lz","Encounter rate of large zooplankton for Small Forage",'h','1','s','m2 g-1 d-1','f')
        fish(SF)%id_enc_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_enc_Lz","Encounter rate of large zooplankton for Small Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(SP)%id_enc_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_enc_Lz","Encounter rate of large zooplankton for Small Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(SD)%id_enc_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_enc_Lz","Encounter rate of large zooplankton for Medium Forage",'h','1','s','m2 g-1 d-1','f')
        fish(MF)%id_enc_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_enc_Lz","Encounter rate of large zooplankton for Medium Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(MP)%id_enc_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_enc_Lz","Encounter rate of large zooplankton for Medium Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(MD)%id_enc_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_enc_Lz","Encounter rate of large zooplankton for Large Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(LP)%id_enc_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_enc_Lz","Encounter rate of large zooplankton for Large Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(LD)%id_enc_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)


    ! Register Encounter rate of forage fish (enc_f):
        ! SF:
        vardesc_temp = vardesc("SF_enc_f","Encounter rate of forage fish for Small Forage",'h','1','s','m2 g-1 d-1','f')
        fish(SF)%id_enc_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_enc_f","Encounter rate of forage fish for Small Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(SP)%id_enc_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_enc_f","Encounter rate of forage fish for Small Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(SD)%id_enc_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_enc_f","Encounter rate of forage fish for Medium Forage",'h','1','s','m2 g-1 d-1','f')
        fish(MF)%id_enc_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_enc_f","Encounter rate of forage fish for Medium Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(MP)%id_enc_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_enc_f","Encounter rate of forage fish for Medium Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(MD)%id_enc_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_enc_f","Encounter rate of forage fish for Large Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(LP)%id_enc_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_enc_f","Encounter rate of forage fish for Large Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(LD)%id_enc_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

    ! Register Encounter rate of pelagic fish (enc_p):
        ! SF:
        vardesc_temp = vardesc("SF_enc_p","Encounter rate of pelagic fish for Small Forage",'h','1','s','m2 g-1 d-1','f')
        fish(SF)%id_enc_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_enc_p","Encounter rate of pelagic fish for Small Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(SP)%id_enc_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_enc_p","Encounter rate of pelagic fish for Small Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(SD)%id_enc_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_enc_p","Encounter rate of pelagic fish for Medium Forage",'h','1','s','m2 g-1 d-1','f')
        fish(MF)%id_enc_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_enc_p","Encounter rate of pelagic fish for Medium Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(MP)%id_enc_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_enc_p","Encounter rate of pelagic fish for Medium Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(MD)%id_enc_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_enc_p","Encounter rate of pelagic fish for Large Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(LP)%id_enc_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_enc_p","Encounter rate of pelagic fish for Large Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(LD)%id_enc_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

    ! Register Encounter rate of demersal fish (enc_d):
        ! SF:
        vardesc_temp = vardesc("SF_enc_d","Encounter rate of demersal fish for Small Forage",'h','1','s','m2 g-1 d-1','f')
        fish(SF)%id_enc_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_enc_d","Encounter rate of demersal fish for Small Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(SP)%id_enc_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_enc_d","Encounter rate of demersal fish for Small Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(SD)%id_enc_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_enc_d","Encounter rate of demersal fish for Medium Forage",'h','1','s','m2 g-1 d-1','f')
        fish(MF)%id_enc_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_enc_d","Encounter rate of demersal fish for Medium Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(MP)%id_enc_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_enc_d","Encounter rate of demersal fish for Medium Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(MD)%id_enc_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_enc_d","Encounter rate of demersal fish for Large Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(LP)%id_enc_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_enc_d","Encounter rate of demersal fish for Large Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(LD)%id_enc_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

    ! Register Encounter rate of benthos (enc_BE):
        ! SF:
        vardesc_temp = vardesc("SF_enc_BE","Encounter rate of benthos for Small Forage",'h','1','s','m2 g-1 d-1','f')
        fish(SF)%id_enc_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_enc_BE","Encounter rate of benthos for Small Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(SP)%id_enc_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_enc_BE","Encounter rate of benthos for Small Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(SD)%id_enc_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_enc_BE","Encounter rate of benthos for Medium Forage",'h','1','s','m2 g-1 d-1','f')
        fish(MF)%id_enc_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_enc_BE","Encounter rate of benthos for Medium Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(MP)%id_enc_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_enc_BE","Encounter rate of benthos for Medium Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(MD)%id_enc_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_enc_BE","Encounter rate of benthos for Large Pelagic",'h','1','s','m2 g-1 d-1','f')
        fish(LP)%id_enc_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_enc_BE","Encounter rate of benthos for Large Demersal",'h','1','s','m2 g-1 d-1','f')
        fish(LD)%id_enc_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

    ! Register Consumption rate of medium zooplankton (cons_Mz):
        ! SF:
        vardesc_temp = vardesc("SF_cons_Mz","Consumption rate of medium zooplankton for Small Forage",'h','1','s','d-1','f')
        fish(SF)%id_cons_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_cons_Mz","Consumption rate of medium zooplankton for Small Pelagic",'h','1','s','d-1','f')
        fish(SP)%id_cons_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_cons_Mz","Consumption rate of medium zooplankton for Small Demersal",'h','1','s','d-1','f')
        fish(SD)%id_cons_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_cons_Mz","Consumption rate of medium zooplankton for Medium Forage",'h','1','s','d-1','f')
        fish(MF)%id_cons_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_cons_Mz","Consumption rate of medium zooplankton for Medium Pelagic",'h','1','s','d-1','f')
        fish(MP)%id_cons_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_cons_Mz","Consumption rate of medium zooplankton for Medium Demersal",'h','1','s','d-1','f')
        fish(MD)%id_cons_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_cons_Mz","Consumption rate of medium zooplankton for Large Pelagic",'h','1','s','d-1','f')
        fish(LP)%id_cons_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_cons_Mz","Consumption rate of medium zooplankton for Large Demersal",'h','1','s','d-1','f')
        fish(LD)%id_cons_Mz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)




    ! Register Consumption rate of large zooplankton (cons_Lz):
        ! SF:
        vardesc_temp = vardesc("SF_cons_Lz","Consumption rate of large zooplankton for Small Forage",'h','1','s','d-1','f')
        fish(SF)%id_cons_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_cons_Lz","Consumption rate of large zooplankton for Small Pelagic",'h','1','s','d-1','f')
        fish(SP)%id_cons_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_cons_Lz","Consumption rate of large zooplankton for Small Demersal",'h','1','s','d-1','f')
        fish(SD)%id_cons_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_cons_Lz","Consumption rate of large zooplankton for Medium Forage",'h','1','s','d-1','f')
        fish(MF)%id_cons_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_cons_Lz","Consumption rate of large zooplankton for Medium Pelagic",'h','1','s','d-1','f')
        fish(MP)%id_cons_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_cons_Lz","Consumption rate of large zooplankton for Medium Demersal",'h','1','s','d-1','f')
        fish(MD)%id_cons_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_cons_Lz","Consumption rate of large zooplankton for Large Pelagic",'h','1','s','d-1','f')
        fish(LP)%id_cons_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_cons_Lz","Consumption rate of large zooplankton for Large Demersal",'h','1','s','d-1','f')
        fish(LD)%id_cons_Lz = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

    ! Register Consumption rate of forage fish (cons_f):
        ! SF:
        vardesc_temp = vardesc("SF_cons_f","Consumption rate of forage fish for Small Forage",'h','1','s','d-1','f')
        fish(SF)%id_cons_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_cons_f","Consumption rate of forage fish for Small Pelagic",'h','1','s','d-1','f')
        fish(SP)%id_cons_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_cons_f","Consumption rate of forage fish for Small Demersal",'h','1','s','d-1','f')
        fish(SD)%id_cons_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_cons_f","Consumption rate of forage fish for Medium Forage",'h','1','s','d-1','f')
        fish(MF)%id_cons_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_cons_f","Consumption rate of forage fish for Medium Pelagic",'h','1','s','d-1','f')
        fish(MP)%id_cons_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_cons_f","Consumption rate of forage fish for Medium Demersal",'h','1','s','d-1','f')
        fish(MD)%id_cons_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_cons_f","Consumption rate of forage fish for Large Pelagic",'h','1','s','d-1','f')
        fish(LP)%id_cons_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_cons_f","Consumption rate of forage fish for Large Demersal",'h','1','s','d-1','f')
        fish(LD)%id_cons_f = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
    
    ! Register Encounter rate of pelagic(cons_p):
        ! SF:
        vardesc_temp = vardesc("SF_cons_p","Encounter rate of pelagicfor Small Forage",'h','1','s','d-1','f')
        fish(SF)%id_cons_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_cons_p","Encounter rate of pelagicfor Small Pelagic",'h','1','s','d-1','f')
        fish(SP)%id_cons_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_cons_p","Encounter rate of pelagicfor Small Demersal",'h','1','s','d-1','f')
        fish(SD)%id_cons_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_cons_p","Encounter rate of pelagicfor Medium Forage",'h','1','s','d-1','f')
        fish(MF)%id_cons_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_cons_p","Encounter rate of pelagicfor Medium Pelagic",'h','1','s','d-1','f')
        fish(MP)%id_cons_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_cons_p","Encounter rate of pelagicfor Medium Demersal",'h','1','s','d-1','f')
        fish(MD)%id_cons_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_cons_p","Encounter rate of pelagicfor Large Pelagic",'h','1','s','d-1','f')
        fish(LP)%id_cons_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_cons_p","Encounter rate of pelagicfor Large Demersal",'h','1','s','d-1','f')
        fish(LD)%id_cons_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

    ! Register Consumption rate of demersal fish (cons_d):
        ! SF:
        vardesc_temp = vardesc("SF_cons_d","Consumption rate of demersal fish for Small Forage",'h','1','s','d-1','f')
        fish(SF)%id_cons_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_cons_d","Consumption rate of demersal fish for Small Pelagic",'h','1','s','d-1','f')
        fish(SP)%id_cons_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_cons_d","Consumption rate of demersal fish for Small Demersal",'h','1','s','d-1','f')
        fish(SD)%id_cons_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_cons_d","Consumption rate of demersal fish for Medium Forage",'h','1','s','d-1','f')
        fish(MF)%id_cons_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_cons_d","Consumption rate of demersal fish for Medium Pelagic",'h','1','s','d-1','f')
        fish(MP)%id_cons_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_cons_d","Consumption rate of demersal fish for Medium Demersal",'h','1','s','d-1','f')
        fish(MD)%id_cons_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_cons_d","Consumption rate of demersal fish for Large Pelagic",'h','1','s','d-1','f')
        fish(LP)%id_cons_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_cons_d","Consumption rate of demersal fish for Large Demersal",'h','1','s','d-1','f')
        fish(LD)%id_cons_d = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

    ! Register Consumption rate of benthos (cons_BE):
        ! SF:
        vardesc_temp = vardesc("SF_cons_BE","Consumption rate of benthos for Small Forage",'h','1','s','d-1','f')
        fish(SF)%id_cons_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_cons_BE","Consumption rate of benthos for Small Pelagic",'h','1','s','d-1','f')
        fish(SP)%id_cons_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_cons_BE","Consumption rate of benthos for Small Demersal",'h','1','s','d-1','f')
        fish(SD)%id_cons_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_cons_BE","Consumption rate of benthos for Medium Forage",'h','1','s','d-1','f')
        fish(MF)%id_cons_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_cons_BE","Consumption rate of benthos for Medium Pelagic",'h','1','s','d-1','f')
        fish(MP)%id_cons_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_cons_BE","Consumption rate of benthos for Medium Demersal",'h','1','s','d-1','f')
        fish(MD)%id_cons_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_cons_BE","Consumption rate of benthos for Large Pelagic",'h','1','s','d-1','f')
        fish(LP)%id_cons_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_cons_BE","Consumption rate of benthos for Large Demersal",'h','1','s','d-1','f')
        fish(LD)%id_cons_BE = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        
    ! Register Total Consumption rate (cons_tot):
        ! SF:
        vardesc_temp = vardesc("SF_cons_tot","Total Consumption rate for Small Forage",'h','1','s','d-1','f')
        fish(SF)%id_cons_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_cons_tot","Total Consumption rate for Small Pelagic",'h','1','s','d-1','f')
        fish(SP)%id_cons_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_cons_tot","Total Consumption rate for Small Demersal",'h','1','s','d-1','f')
        fish(SD)%id_cons_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_cons_tot","Total Consumption rate for Medium Forage",'h','1','s','d-1','f')
        fish(MF)%id_cons_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_cons_tot","Total Consumption rate for Medium Pelagic",'h','1','s','d-1','f')
        fish(MP)%id_cons_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_cons_tot","Total Consumption rate for Medium Demersal",'h','1','s','d-1','f')
        fish(MD)%id_cons_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_cons_tot","Total Consumption rate for Large Pelagic",'h','1','s','d-1','f')
        fish(LP)%id_cons_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_cons_tot","Total Consumption rate for Large Demersal",'h','1','s','d-1','f')
        fish(LD)%id_cons_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        
    ! Register Feeding level (f_tot):
        ! SF:
        vardesc_temp = vardesc("SF_f_tot","Feeding level for Small Forage",'h','1','s','','f')
        fish(SF)%id_f_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_f_tot","Feeding level for Small Pelagic",'h','1','s','','f')
        fish(SP)%id_f_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_f_tot","Feeding level for Small Demersal",'h','1','s','','f')
        fish(SD)%id_f_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_f_tot","Feeding level for Medium Forage",'h','1','s','','f')
        fish(MF)%id_f_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_f_tot","Feeding level for Medium Pelagic",'h','1','s','','f')
        fish(MP)%id_f_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_f_tot","Feeding level for Medium Demersal",'h','1','s','','f')
        fish(MD)%id_f_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_f_tot","Feeding level for Large Pelagic",'h','1','s','','f')
        fish(LP)%id_f_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_f_tot","Feeding level for Large Demersal",'h','1','s','','f')
        fish(LD)%id_f_tot = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

    ! Register Predation mortality rate (mu_p):
        ! SF:
        vardesc_temp = vardesc("SF_mu_p","Predation mortality rate for Small Forage",'h','1','s','d-1','f')
        fish(SF)%id_mu_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_mu_p","Predation mortality rate for Small Pelagic",'h','1','s','d-1','f')
        fish(SP)%id_mu_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_mu_p","Predation mortality rate for Small Demersal",'h','1','s','d-1','f')
        fish(SD)%id_mu_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_mu_p","Predation mortality rate for Medium Forage",'h','1','s','d-1','f')
        fish(MF)%id_mu_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_mu_p","Predation mortality rate for Medium Pelagic",'h','1','s','d-1','f')
        fish(MP)%id_mu_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_mu_p","Predation mortality rate for Medium Demersal",'h','1','s','d-1','f')
        fish(MD)%id_mu_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_mu_p","Predation mortality rate for Large Pelagic",'h','1','s','d-1','f')
        fish(LP)%id_mu_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_mu_p","Predation mortality rate for Large Demersal",'h','1','s','d-1','f')
        fish(LD)%id_mu_p = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

    ! Register Available energy (E_A):
        ! SF:
        vardesc_temp = vardesc("SF_E_A","Available energy for Small Forage",'h','1','s','d-1','f')
        fish(SF)%id_E_A= register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_E_A","Available energy for Small Pelagic",'h','1','s','d-1','f')
        fish(SP)%id_E_A = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_E_A","Available energy for Small Demersal",'h','1','s','d-1','f')
        fish(SD)%id_E_A = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_E_A","Available energy for Medium Forage",'h','1','s','d-1','f')
        fish(MF)%id_E_A = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_E_A","Available energy for Medium Pelagic",'h','1','s','d-1','f')
        fish(MP)%id_E_A = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_E_A","Available energy for Medium Demersal",'h','1','s','d-1','f')
        fish(MD)%id_E_A = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_E_A","Available energy for Large Pelagic",'h','1','s','d-1','f')
        fish(LP)%id_E_A = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_E_A","Available energy for Large Demersal",'h','1','s','d-1','f')
        fish(LD)%id_E_A = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        
    ! Register Productivity (prod):
        ! SF:
        vardesc_temp = vardesc("SF_prod","Productivity for Small Forage",'h','1','s','g WW m-2 d-1','f')
        fish(SF)%id_prod = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_prod","Productivity for Small Pelagic",'h','1','s','g WW m-2 d-1','f')
        fish(SP)%id_prod = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_prod","Productivity for Small Demersal",'h','1','s','g WW m-2 d-1','f')
        fish(SD)%id_prod = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_prod","Productivity for Medium Forage",'h','1','s','g WW m-2 d-1','f')
        fish(MF)%id_prod = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_prod","Productivity for Medium Pelagic",'h','1','s','g WW m-2 d-1','f')
        fish(MP)%id_prod = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_prod","Productivity for Medium Demersal",'h','1','s','g WW m-2 d-1','f')
        fish(MD)%id_prod = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_prod","Productivity for Large Pelagic",'h','1','s','g WW m-2 d-1','f')
        fish(LP)%id_prod = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_prod","Productivity for Large Demersal",'h','1','s','g WW m-2 d-1','f')
        fish(LD)%id_prod = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
    
    ! Register Rate of biomass next size class (Fout):
        ! SF:
        vardesc_temp = vardesc("SF_Fout","Rate of biomass next size class for Small Forage",'h','1','s','d-1','f')
        fish(SF)%id_Fout = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_Fout","Rate of biomass next size class for Small Pelagic",'h','1','s','d-1','f')
        fish(SP)%id_Fout = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_Fout","Rate of biomass next size class for Small Demersal",'h','1','s','d-1','f')
        fish(SD)%id_Fout = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_Fout","Rate of biomass next size class for Medium Forage",'h','1','s','d-1','f')
        fish(MF)%id_Fout = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_Fout","Rate of biomass next size class for Medium Pelagic",'h','1','s','d-1','f')
        fish(MP)%id_Fout = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_Fout","Rate of biomass next size class for Medium Demersal",'h','1','s','d-1','f')
        fish(MD)%id_Fout = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_Fout","Rate of biomass next size class for Large Pelagic",'h','1','s','d-1','f')
        fish(LP)%id_Fout = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_Fout","Rate of biomass next size class for Large Demersal",'h','1','s','d-1','f')
        fish(LD)%id_Fout = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        
    ! Register Reproduction rate (rho):
        ! SF:
        vardesc_temp = vardesc("SF_rho","Reproduction rate for Small Forage",'h','1','s','d-1','f')
        fish(SF)%id_rho = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_rho","Reproduction rate for Small Pelagic",'h','1','s','d-1','f')
        fish(SP)%id_rho = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_rho","Reproduction rate for Small Demersal",'h','1','s','d-1','f')
        fish(SD)%id_rho = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_rho","Reproduction rate for Medium Forage",'h','1','s','d-1','f')
        fish(MF)%id_rho = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_rho","Reproduction rate for Medium Pelagic",'h','1','s','d-1','f')
        fish(MP)%id_rho = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_rho","Reproduction rate for Medium Demersal",'h','1','s','d-1','f')
        fish(MD)%id_rho = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_rho","Reproduction rate for Large Pelagic",'h','1','s','d-1','f')
        fish(LP)%id_rho = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_rho","Reproduction rate for Large Demersal",'h','1','s','d-1','f')
        fish(LD)%id_rho = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

        ! Register Fishing yield (yield):
        ! SF:
        vardesc_temp = vardesc("SF_yield","Fishing yield for Small Forage",'h','1','s','g WW m-2 d-1','f')
        fish(SF)%id_yield = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SP:
        vardesc_temp = vardesc("SP_yield","Fishing yield for Small Pelagic",'h','1','s','g WW m-2 d-1','f')
        fish(SP)%id_yield = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! SD:
        vardesc_temp = vardesc("SD_yield","Fishing yield for Small Demersal",'h','1','s','g WW m-2 d-1','f')
        fish(SD)%id_yield = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MF:
        vardesc_temp = vardesc("MF_yield","Fishing yield for Medium Forage",'h','1','s','g WW m-2 d-1','f')
        fish(MF)%id_yield = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MP:
        vardesc_temp = vardesc("MP_yield","Fishing yield for Medium Pelagic",'h','1','s','g WW m-2 d-1','f')
        fish(MP)%id_yield = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! MD:
        vardesc_temp = vardesc("MD_yield","Fishing yield for Medium Demersal",'h','1','s','g WW m-2 d-1','f')
        fish(MD)%id_yield = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LP:
        vardesc_temp = vardesc("LP_yield","Fishing yield for Large Pelagic",'h','1','s','g WW m-2 d-1','f')
        fish(LP)%id_yield = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)
        ! LD:
        vardesc_temp = vardesc("LD_yield","Fishing yield for Large Demersal",'h','1','s','g WW m-2 d-1','f')
        fish(LD)%id_yield = register_diag_field(package_name, vardesc_temp%name, axes(1:2),&
            init_time, vardesc_temp%longname,vardesc_temp%units, missing_value = missing_value1)

end subroutine generic_FEISTY_register_diag



!#######################################################################
! <SUBROUTINE NAME="generic_FEISTY_update_from_coupler">
!  <OVERVIEW>
!   Modify the values obtained from the coupler if necessary.
!  </OVERVIEW>
!  <DESCRIPTION>
!   Some tracer fields could be modified after values are obtained from the 
!   coupler. This subroutine is the place for specific tracer manipulations.
!   FEISTY currently does not use this.
!  </DESCRIPTION>
!  <TEMPLATE>
!   call generic_FEISTY_update_from_coupler(tracer_list) 
!  </TEMPLATE>
!  <IN NAME="tracer_list" TYPE="type(g_tracer_type), pointer">
!   Pointer to the head of generic tracer list.
!  </IN>
! </SUBROUTINE>
subroutine generic_FEISTY_update_from_coupler(tracer_list)
    type(g_tracer_type), pointer, intent(inout) :: tracer_list
    character(len=fm_string_len), parameter :: sub_name = 'generic_FEISTY_update_from_coupler'
end subroutine generic_FEISTY_update_from_coupler
 


!#######################################################################
! <SUBROUTINE NAME="user_add_params">
!   <OVERVIEW>
!       Add all the known experimental parameters used in the 
!       calculation made in the generic_FEISTY module
!   </OVERVIEW>
!   <DESCRIPTION>
!       This is an internal subroutine, not a public interface, therefore
!       all the parameters added will only be used in this module. 
!       This implementation enables runtime overwrite via field_table.
!       The pointer are not defined in user_add_params
!   </DESCRIPTION>
!   <TEMPLATE>
!       Start parameter list: g_tracer_start_param_list(package_name)
!           g_tracer_add_param('param_name', FEISTY%param_name, VALUE)
!           call g_tracer_add_param('', FEISTY%, )
!       Stop parameter list: g_tracer_end_param_list(package_name)       
!   </TEMPLATE>
! </SUBROUTINE>
subroutine user_add_params_FEISTY
    ! Initialiser param list:     
    call g_tracer_start_param_list(package_name)
    
    ! versions: 
    call g_tracer_add_param('Name', FEISTY%name, 'FEISTY')
    call g_tracer_add_param('version', FEISTY%version, '_setupbasic2' )
	
    !
    ! FEISTY parameters: -------------------------------------------------------
    !
 

    ! Functional Group information: ---------------------------------------------
    call g_tracer_add_param('nFishGroup', FEISTY%nFishGroup, int(8)) ! Number of fish functional group
    call g_tracer_add_param('nBenthos', FEISTY%nBenthos, int(1))     ! Benthic resource 
    call g_tracer_add_param('nMesoZoo', FEISTY%nMesoZoo, int(2))     ! Benthic resource 
    call g_tracer_add_param('nDeriv', FEISTY%nDeriv, FEISTY%nFishGroup + FEISTY%nBenthos)       ! Number of group for witch the derivative is calculated

    call g_tracer_add_param('zero', FEISTY%zero, 0.0)               ! Zero
    call g_tracer_add_param('eps', FEISTY%eps, 1e-30)               ! Small number for divisions 
    call g_tracer_add_param('d2s', FEISTY%d2s, 24.0*60.0*60.0)      ! conversion second to day
    call g_tracer_add_param('y2d', FEISTY%y2d, 365.0)               ! conversion day to year 
    call g_tracer_add_param('IC', FEISTY%IC,  10.0**(-5))            ! value for initial condition    
    call g_tracer_add_param('conv_m2_to_m2', FEISTY%conv_m2_to_m2, 100.0)

    ! Parameters physiology: ------------------------------------------
    call g_tracer_add_param('ke', FEISTY%ke, 0.0630)                ! [°c-1]                Temperature correction for cmax and encounter
    call g_tracer_add_param('kmet', FEISTY%kmet, 0.08550)           ! [°c-1]                Temperature correction for Metabolic cost cost
    call g_tracer_add_param('a_enc', FEISTY%a_enc, a_enc)     !      ! []                   Coeff for mass-specific Encounter rate             
    call g_tracer_add_param('k_fct_tp', FEISTY%k_fct_tp, k_fct_tp)                       ! []                    Coefficient for the functional response type! if k =1 then type 2 if k .gt. 1 type 3 
    call g_tracer_add_param('b_enc', FEISTY%b_enc, 0.20)            ! [m-2 g^(b_enc−1) d−1] Exponent for mass-specific Encounter rate 
    call g_tracer_add_param('a_cmax', FEISTY%a_cmax, 20.0)          ! [d g^(b_cmax)]        Coeff for Cmax 
    call g_tracer_add_param('b_cmax', FEISTY%b_cmax, 0.250)         ! []                    Exponent for Cmax 
    call g_tracer_add_param('a_met', FEISTY%a_met, 0.2*FEISTY%a_cmax)! [d-1 g^(b_met)]       Coeff for Metabolic loss 
    call g_tracer_add_param('b_met', FEISTY%b_met, 0.1750)          ! []                    Exponent for Metabolic cost 
    call g_tracer_add_param('alpha', FEISTY%alpha, 0.70)            ! []                    Assimilation efficiency 
    call g_tracer_add_param('Nat_mrt', FEISTY%Nat_mrt, 0.10/365.0)  ! [m-2 d-1]             Natural mortality coeffient 
    ! Fishing : ---------------------------------------------------------
    call g_tracer_add_param('Frate', FEISTY%Frate, 0.30/FEISTY%y2d) ! [d-1]                 Fishing intensity 
    call g_tracer_add_param('Jselct', FEISTY%Jselct, 0.10)          ! []                    Fishing Selectivity of juveniles  
    call g_tracer_add_param('Aselct', FEISTY%Aselct, 1.0)           ! []                    Fishing Selectivity of adult 

    ! Param for Size-class growth rate: ----------------------------------
    call g_tracer_add_param('Z_s', FEISTY%Z_s, 0.0010/0.50)       ! Small fish Ratio of upper and lower body size boundary 
    call g_tracer_add_param('Z_m', FEISTY%Z_m, 0.50/250.0)        ! Medium fish Ratio of upper and lower body size boundary 
    call g_tracer_add_param('Z_l', FEISTY%Z_l, 250.0/125000.0)    ! Large fish Ratio of upper and lower body size boundary 
    call g_tracer_add_param('kappa_l', FEISTY%kappa_l, 1.0)       ! Larval Fraction of energy available (E_a) invested in growth 
    call g_tracer_add_param('kappa_j', FEISTY%kappa_j, 1.0)       ! Juvenile Fraction of energy available (E_a) invested in growth 
    call g_tracer_add_param('kappa_a', FEISTY%kappa_a, 0.50)      ! Adult Fraction of energy available (E_a) invested in growth 
    call g_tracer_add_param('eps_R', FEISTY%eps_R, 0.010)         ! Reproduction efficiency: account for energy spend in reprodutive organe, aditional foraging activities, cost of migration, and death from egg release to hatchement. 
    ! Benthic chemostat
    call g_tracer_add_param('beta', FEISTY%beta, 0.0750)          ! Benthic Efficiency from detritus to benthic biomass
    call g_tracer_add_param('CC', FEISTY%CC, 80.0)                ! Carring Capacity for benthic chemostat

    ! Parameters feeding preferences: ---------------------------------
    call g_tracer_add_param('Sm', FEISTY%Sm, 0.25)                        ! Medium size feeding on Medium Zoo
    call g_tracer_add_param('D', FEISTY%D, 0.750)                         ! Demersal feeding in pelagic reduction
    call g_tracer_add_param('A', FEISTY%A, 0.50)                          ! Adult predation reduction
    call g_tracer_add_param('pref_Mz', FEISTY%pref_Mz, 1.0 )              ! Preference Small fish for medium mesozooplankton group
    ! Medium Forage 
    call g_tracer_add_param('pref_Mf_Mz', FEISTY%pref_Mf_Mz, 0.25)        ! Preference for Medium Mesozooplankton   
    call g_tracer_add_param('pref_Mf_Lz', FEISTY%pref_Mf_Lz, 1.0)         ! Preference for Large Mesozooplankton
    call g_tracer_add_param('pref_Mf_S', FEISTY%pref_Mf_S, 1.0)           ! Preference for small fish
    ! Medium pelagic 
    call g_tracer_add_param('pref_Mp_Mz', FEISTY%pref_Mp_Mz, FEISTY%Sm)             ! Preference for Medium Mesozooplankton
    call g_tracer_add_param('pref_Mp_Lz', FEISTY%pref_Mp_Lz, 1.0)                   ! Preference for Large Mesozooplankton
    call g_tracer_add_param('pref_Mp_S', FEISTY%pref_Mp_S, 1.0)                     ! Preference for small fish
    ! Medium Demersal 
    call g_tracer_add_param('pref_Md_BE', FEISTY%pref_Md_BE, 1.0/100.00)                   ! Preference for Benthos
    ! Large Pelagic
    call g_tracer_add_param('pref_Lp_Mf', FEISTY%pref_Lp_Mf, FEISTY%A)              ! Preference for Medium forage
    call g_tracer_add_param('pref_Lp_Mp', FEISTY%pref_Lp_Mp, 1.0) 
    ! Large Demersal
    call g_tracer_add_param('pref_Ld_Mf', FEISTY%pref_Ld_Mf, FEISTY%D*FEISTY%A)     ! Preference for Medium forage
    call g_tracer_add_param('pref_Ld_Mp', FEISTY%pref_Ld_Mp, FEISTY%D)              ! Preference for Medium pelagics
    call g_tracer_add_param('pref_Ld_Md', FEISTY%pref_Ld_Md, 1.0/100.00)            ! Preference for Medium Demersal
    call g_tracer_add_param('pref_Ld_BE', FEISTY%pref_Ld_BE, 1.0/100.00)            ! Preference for Benthos

    call g_tracer_add_param('Bent_eff'  , FEISTY%Bent_eff  , 0.075)

    ! Conversion from cobalt zooplankton and detritus to FEISTY  
    call g_tracer_add_param('convers_Mz', FEISTY%convers_Mz, 6.625*12.01*9.0 * 1000.0)       ! zooplankton biomass unit conversion conversion 
    call g_tracer_add_param('convers_det', FEISTY%convers_det, 6.625*12.01*9.0*FEISTY%d2s)   ! detritus unit conversion

    call g_tracer_add_param('PI_be_cutoff', FEISTY%PI_be_cutoff, 200.0)   ! demersal time in pel cutoff
    
   
	! Stop param list:    
    call g_tracer_end_param_list(package_name)

end subroutine user_add_params_FEISTY


! End FEISTY time step 
subroutine generic_FEISTY_end
    character(len=fm_string_len), parameter :: sub_name = 'generic_FEISTY_end'
    call user_deallocate_arrays_FEISTY
end subroutine generic_FEISTY_end


! Allocate arrays at the end of a time step
subroutine user_allocate_arrays_FEISTY
    integer :: isc,iec,jsc,jec,isd,ied,jsd,jed,nk,ntau, m

    call g_tracer_get_common(isc,iec,jsc,jec,isd,ied,jsd,jed,nk,ntau)
    
    allocate(FEISTY%Sf_B(isd:ied,jsd:jed));     
    allocate(FEISTY%Sp_B(isd:ied,jsd:jed));     
    allocate(FEISTY%Sd_B(isd:ied,jsd:jed));     
    allocate(FEISTY%Mf_B(isd:ied,jsd:jed));     
    allocate(FEISTY%Mp_B(isd:ied,jsd:jed));     
    allocate(FEISTY%Md_B(isd:ied,jsd:jed));     
    allocate(FEISTY%Lp_B(isd:ied,jsd:jed));     
    allocate(FEISTY%Ld_B(isd:ied,jsd:jed));     
    allocate(FEISTY%BE_B(isd:ied,jsd:jed));     
    allocate(FEISTY%dBdt_BE(isd:ied,jsd:jed));         FEISTY%dBdt_BE  = 0.0 ! Derivative for Benthic resource

    ! Diagnostic variables: 
    do m = 1, FEISTY%nFishGroup
        allocate(fish(m)%met(isd:ied,jsd:jed));        fish(m)%met = 0.0   		    !    Metabolic rate

        allocate(fish(m)%enc_Mz(isd:ied,jsd:jed));     fish(m)%enc_Mz = 0.0 	        !    Encounter rate of medium zooplankton
        allocate(fish(m)%enc_Lz(isd:ied,jsd:jed));     fish(m)%enc_Lz = 0.0	        !    Encounter rate of large zooplankton
        allocate(fish(m)%enc_f(isd:ied,jsd:jed));      fish(m)%enc_f = 0.0	            !    Encounter rate of forage fish
        allocate(fish(m)%enc_p(isd:ied,jsd:jed));      fish(m)%enc_p = 0.0 	        !    Encounter rate of pelagic fish
        allocate(fish(m)%enc_d(isd:ied,jsd:jed));      fish(m)%enc_d = 0.0 	        !    Encounter rate of demersal fish
        allocate(fish(m)%enc_BE(isd:ied,jsd:jed));     fish(m)%enc_BE = 0.0 	        !    Encounter rate of benthos

        allocate(fish(m)%cons_Mz(isd:ied,jsd:jed));    fish(m)%cons_Mz = 0.0 	            !    Consumption rate of medium zooplankton
        allocate(fish(m)%cons_Lz(isd:ied,jsd:jed));    fish(m)%cons_Lz = 0.0 	            !    Consumption rate of large zooplankton
        allocate(fish(m)%cons_f(isd:ied,jsd:jed));     fish(m)%cons_f = 0.0 	            !    Consumption rate of forage fish
        allocate(fish(m)%cons_p(isd:ied,jsd:jed));     fish(m)%cons_p = 0.0 	            !    Consumption rate of large pelagic fish
        allocate(fish(m)%cons_d(isd:ied,jsd:jed));     fish(m)%cons_d = 0.0 	            !    Consumption rate of demersal fish
        allocate(fish(m)%cons_BE(isd:ied,jsd:jed));    fish(m)%cons_BE = 0.0	            !    Consumption rate of benthos
        allocate(fish(m)%cons_tot(isd:ied,jsd:jed));   fish(m)%cons_tot = 0.0 	            !    Total Consumption rate 

        allocate(fish(m)%f_tot(isd:ied,jsd:jed));      fish(m)%f_tot = 0.0 	                !    Feeding level = Tot_con / Cmax
        allocate(fish(m)%mu_p(isd:ied,jsd:jed));       fish(m)%mu_p = 0.0 	                !    Predation mortality rate
        allocate(fish(m)%E_A(isd:ied,jsd:jed));        fish(m)%E_A = 0.0 		            !    Rate of biomass accumulation/ Available energy
        allocate(fish(m)%prod(isd:ied,jsd:jed));       fish(m)%prod = 0.0 	                !    Productivity = E_A* Biomass
        allocate(fish(m)%Fout(isd:ied,jsd:jed));       fish(m)%Fout = 0.0 	                !    flux of biomass to next size class
        allocate(fish(m)%rho(isd:ied,jsd:jed));        fish(m)%rho = 0.0 		            !    rho
        allocate(fish(m)%yield(isd:ied,jsd:jed));      fish(m)%yield = 0.0                  !    Yield = nu_F * Biomass 

        allocate(fish(m)%dBdt_fish(isd:ied,jsd:jed));  fish(m)%dBdt_fish = 0.0              ! Derivative for fish in m-2 d-1
    end do 
end subroutine user_allocate_arrays_FEISTY


! Deallocate arrays at the end of a time step
subroutine user_deallocate_arrays_FEISTY
    integer :: m 

    deallocate(FEISTY%Sf_B)
    deallocate(FEISTY%Sp_B)
    deallocate(FEISTY%Sd_B)
    deallocate(FEISTY%Mf_B)
    deallocate(FEISTY%Mp_B)
    deallocate(FEISTY%Md_B)
    deallocate(FEISTY%Lp_B)
    deallocate(FEISTY%Ld_B)
    deallocate(FEISTY%BE_B)
    deallocate(FEISTY%dBdt_BE)

    do m = 1, FEISTY%nFishGroup
        deallocate(fish(m)%met) 		    !    Metabolic rate
    	
        deallocate(fish(m)%enc_Mz) 	    !    Encounter rate of medium zooplankton
    	deallocate(fish(m)%enc_Lz) 	    !    Encounter rate of large zooplankton
    	deallocate(fish(m)%enc_f) 	    !    Encounter rate of forage fish
    	deallocate(fish(m)%enc_p) 	    !    Encounter rate of pelagic fish
    	deallocate(fish(m)%enc_d) 	    !    Encounter rate of demersal fish
    	deallocate(fish(m)%enc_BE) 	    !    Encounter rate of benthos

    	deallocate(fish(m)%cons_Mz) 	    !    Consumption rate of medium zooplankton
    	deallocate(fish(m)%cons_Lz) 	    !    Consumption rate of large zooplankton
    	deallocate(fish(m)%cons_f) 	        !    Consumption rate of forage fish
    	deallocate(fish(m)%cons_p) 	        !    Consumption rate of large pelagic fish
    	deallocate(fish(m)%cons_d) 	        !    Consumption rate of demersal fish
    	deallocate(fish(m)%cons_BE) 	    !    Consumption rate of benthos
    	deallocate(fish(m)%cons_tot) 	    !    Total Consumption rate 

    	deallocate(fish(m)%f_tot) 	        !    Feeding level = Tot_con / Cmax
    	deallocate(fish(m)%mu_p) 	        !    Predation mortality rate
    	deallocate(fish(m)%E_A) 		    !    Rate of biomass accumulation/ Available energy
    	deallocate(fish(m)%prod) 	        !    Productivity = E_A* Biomass
    	deallocate(fish(m)%Fout) 	        !    flux of biomass to next size class
    	deallocate(fish(m)%rho) 		    !    rho
    	deallocate(fish(m)%yield)           !    Yield = nu_F * Biomass 

        deallocate(fish(m)%dBdt_fish)       ! Derivative for fish in m-2 d-1 
    end do 
end subroutine user_deallocate_arrays_FEISTY



!#######################################################################
! <SUBROUTINE NAME="user_add_tracers_FEISTY">
!   <OVERVIEW>
!       Add all tracer fields taht shall be registered for diag output
!   </OVERVIEW>
!   <DESCRIPTION>
!       Specify all prognostic tracers of the generic_FEISTY module
!       !! These are only the tracers that need to get passed over time steps !! 
!       Parameters that are required at the time of registration can 
!       can be specify at the beginning: So far FEISTY does not include
!       such parameters.
!   </DESCRIPTION>
!   <TEMPLATE>
!       Parameters:-------------------------------------------------
!       Start parameter list: g_tracer_start_param_list(package_name)
!           call g_tracer_add_param('', FEISTY%, )
!       Stop parameter list: g_tracer_end_param_list(package_name) 
!       
!       Tracers: ---------------------------------------------------
!       User adds one call for each prognostic tracer below!
!       Not for FEISTY: User should specify if fluxes must be extracted from boundary
!       by passing one or more of the following methods as .true.
!       and provide the corresponding parameters array
!       methods: flux_gas, flux_runoff, flux_wetdep,flux_drydep
!
!       Pass an init_value arg if the tracers should be initialized to a nonzero value everywhere
!       otherwise they will be initialized to zero. (biomass is setup with non-nul initial conditions )
!
!       call g_tracer_add(tracer_list,package_name,&
!            name       = 'SFfish',         &
!            longname   = 'small forage fish biomass',  &
!            units      = 'g/m2',      &
!            prog       = .false.,
!            init_value     = 0.001      )   
!        
!       prog = .true. or .false
!       if prog == .true. then pointer           
!   </TEMPLATE>
! </SUBROUTINE>
subroutine user_add_tracers_FEISTY(tracer_list)
  type(g_tracer_type), pointer :: tracer_list
  character(len=fm_string_len), parameter :: sub_name = 'user_add_tracers_FEISTY'
    ! Add here only the parameters that are required at the time of registeration
    ! (to make flux exchanging Ocean tracers known for all PE's)
    ! call g_tracer_start_param_list(package_name)
    !   call g_tracer_add_param(''   , FEISTY% , '')
    !   call g_tracer_end_param_list(package_name)
    ! Set Restart files
    !    call g_tracer_set_files(ice_restart_file = cobalt%ice_restart_file,&
    !         ocean_restart_file  = cobalt%ocean_restart_file )

    !=====================================================
    ! All tracer fields shall be registered for diag output.
    !=====================================================
    
    !===========================================================
    !Prognostic Tracers - needs to be kept for the next time step 
    !===========================================================
    ! Note: the following prognostic tracers, i.e., that are passed to the next 
    ! if prog = .true. then pass 'field' as argument in the function 
    ! g_tracer_get_values(tracer_list,'name' ,'field', FEISTYt%name, isd, jsd, ntau=tau)

    call g_tracer_add(tracer_list, package_name,&
        name       = 'Sf_B',         &
        longname   = 'Small forage fish biomass',  &
        units      = 'g m-2',      &
        btm_reservoir = .true.,         &
        prog       = .false.,           &
        init_value = FEISTY%IC)

    call g_tracer_add(tracer_list, package_name,&
        name       = 'Mf_B',         &
        longname   = 'Medium forage fish biomass',  &
        units      = 'g m-2',      &
        btm_reservoir = .true.,         &
        prog       = .false.,           &
        init_value = FEISTY%IC)

    call g_tracer_add(tracer_list,package_name,&
        name       = 'Sp_B',         &
        longname   = 'Small large pelagic fish biomass',  &
        units      = 'g m-2',      &
        btm_reservoir = .true.,         &
        prog       = .false.,           &
        init_value = FEISTY%IC)

    call g_tracer_add(tracer_list,package_name,&
        name       = 'Mp_B',         &
        longname   = 'Medium large pelagic fish biomass',  &
        units      = 'g m-2',      &
        btm_reservoir = .true.,         &
        prog       = .false.,           &
        init_value = FEISTY%IC)			

    call g_tracer_add(tracer_list,package_name,&
        name       = 'Lp_B',         &
        longname   = 'Large pelagic fish biomass',  &
        units      = 'g m-2',      &
        btm_reservoir = .true.,         &
        prog       = .false.,           &
        init_value = FEISTY%IC)

    call g_tracer_add(tracer_list,package_name,&
        name       = 'Sd_B',         &
        longname   = 'Small demersal fish biomass',  &
        units      = 'g m-2',      &
        btm_reservoir = .true.,         &
        prog       = .false.,           &
        init_value = FEISTY%IC)

    call g_tracer_add(tracer_list,package_name,&
        name       = 'Md_B',         &
        longname   = 'Medium demersal fish biomass',  &
        units      = 'g m-2',      &
        btm_reservoir = .true.,         &
        prog       = .false.,           &
        init_value = FEISTY%IC)

    call g_tracer_add(tracer_list,package_name,&
        name       = 'Ld_B',         &
        longname   = 'Large demersal fish biomass',  &
        units      = 'g m-2',      &
        btm_reservoir = .true.,         &
        prog       = .false.,           &
        init_value = FEISTY%IC)			

    call g_tracer_add(tracer_list,package_name,&
        name       = 'BE_B',         &
        longname   = 'Benthic invertebrate biomass',  &
        units      = 'g m-2',      &
        btm_reservoir = .true.,         &
        prog       = .false.,           &
        init_value = FEISTY%IC)

end subroutine user_add_tracers_FEISTY



! Get tracer values to make next time step calculation. 
! This function as to be called before starting the calculation of the Fish derivative as it 
! the value to use for each tracer! 
subroutine generic_FEISTY_tracer_get_values(tracer_list, isd, jsd, tau)
    type(g_tracer_type), pointer :: tracer_list
    integer, intent(in) :: isd, jsd, tau 

    ! Get values of the prognostic variable : ----------------------------------------------
    call g_tracer_get_values(tracer_list, 'Sf_B' ,'btm_reservoir', FEISTY%Sf_B(:,:), isd, jsd)
    call g_tracer_get_values(tracer_list, 'Sp_B' ,'btm_reservoir', FEISTY%Sp_B(:,:), isd, jsd)
    call g_tracer_get_values(tracer_list, 'Sd_B' ,'btm_reservoir', FEISTY%Sd_B(:,:), isd, jsd)
    call g_tracer_get_values(tracer_list, 'Mf_B' ,'btm_reservoir', FEISTY%Mf_B(:,:), isd, jsd)
    call g_tracer_get_values(tracer_list, 'Mp_B' ,'btm_reservoir', FEISTY%Mp_B(:,:), isd, jsd)
    call g_tracer_get_values(tracer_list, 'Md_B' ,'btm_reservoir', FEISTY%Md_B(:,:), isd, jsd)
    call g_tracer_get_values(tracer_list, 'Lp_B' ,'btm_reservoir', FEISTY%Lp_B(:,:), isd, jsd)
    call g_tracer_get_values(tracer_list, 'Ld_B' ,'btm_reservoir', FEISTY%Ld_B(:,:), isd, jsd)
    call g_tracer_get_values(tracer_list, 'BE_B' ,'btm_reservoir', FEISTY%BE_B(:,:), isd, jsd)

end subroutine generic_FEISTY_tracer_get_values


! Get the pointer to latter give  new tracer's value using pointers.
! see subroutine generic_FEISTY_update_pointer
! This function as to be called before calculating the new tracer value from ODEs  
subroutine generic_FEISTY_tracer_get_pointer(tracer_list)
    type(g_tracer_type), pointer :: tracer_list

    call g_tracer_get_pointer(tracer_list,'Sf_B','field', FEISTY%p_Sf_B)
    call g_tracer_get_pointer(tracer_list,'Sp_B','field', FEISTY%p_Sp_B)
    call g_tracer_get_pointer(tracer_list,'Sd_B','field', FEISTY%p_Sd_B)
    call g_tracer_get_pointer(tracer_list,'Mf_B','field', FEISTY%p_Mf_B)
    call g_tracer_get_pointer(tracer_list,'Mp_B','field', FEISTY%p_Mp_B)
    call g_tracer_get_pointer(tracer_list,'Md_B','field', FEISTY%p_Md_B)
    call g_tracer_get_pointer(tracer_list,'Lp_B','field', FEISTY%p_Lp_B)
    call g_tracer_get_pointer(tracer_list,'Ld_B','field', FEISTY%p_Ld_B)
    call g_tracer_get_pointer(tracer_list,'BE_B','field', FEISTY%p_BE_B)

end subroutine generic_FEISTY_tracer_get_pointer



!#######################################################################
! <SUBROUTINE NAME="FEISTY_fish_derivative">
!   <OVERVIEW>
!       Calculation of of next time step biomass of fish 
!   </OVERVIEW>
!   <DESCRIPTION>
!       Calculation of the mass balance of fish (growth, reproduction, 
!       ingestion, predation on zooplankton) and the next time step biomass
!       of each fish and benthic resources.
!   </DESCRIPTION>
! 
!
! INPUT: temp,                  ! Temperature 
!        O2,                    ! Oxygen Concentration
!        prey_vec,              ! Mesozooplanton concentration (idx = 7:8) 
!        hp_ingest_vec          ! High trophic level ingestion rate (idx = 7:8)
!        dt                     ! Cobalt time step (days)
!        Delta_t                ! Time step conversion from cobalt to FEISTY 
!        NUM_PREY               ! Number of types from COBALT
!
! Note: Oxygen is not used but might be if oxygen budget of fish in included in the current FEISTY version.
!
! OUTPUT: hp_ingest_vec
!         fish(m)%B  
!  
! Potential developpement: calculating and returning excretion by higher predators
! Converting input prey_vec units 
! 
! </DESCRIPTION>
subroutine generic_FEISTY_fish_update_from_source(tracer_list, i, j, nk, NUM_PREY, &
                                                  Temp, det, dt, zt, dzt, &
                                                  med_zoo_N, Lrg_zoo_N, &
                                                  hp_ingest_nmdz, hp_ingest_nlgz) ! dzt(i,j,1)

    type(g_tracer_type),               pointer :: tracer_list
    integer,                        intent(in) :: i, j, nk, NUM_PREY
    real, dimension(nk),            intent(in) :: Temp
    real,                        intent(inout) :: det  ! Flux detritus at the bottom layer (fn_residual_btm in COBALT)
    real,                           intent(in) :: dt
    real, dimension(nk),            intent(in) :: zt, dzt ! layer depth and thikness
    real, dimension(nk),            intent(in) :: med_zoo_N, Lrg_zoo_N          ! Medium and Large zooplankton concentration (mol N Kg-1)
    real, dimension(nk),         intent(inout) :: hp_ingest_nmdz, hp_ingest_nlgz ! high trophic level ingestion rate (mol N Kg-1 s-1)
   
    ! Internal variables : ---------------------------------------------------
    real :: Tp, Tb
    real :: biop, biob
    real, dimension(FEISTY%nFishGroup) :: Texp ! Temperature experienced, and time in pelagic zone
    real, dimension(FEISTY%nFishGroup) :: tpel

    real :: Delta_t             ! conversion from COBALT to FEISTY time step 
    real :: pred_BE             ! predation on benthic resource 
    real :: r_BE                ! Benthic growth rate
    real, dimension(11) :: Resource ! total prey than a predator can encounter (used in type III functional response calculation)

    integer :: m                ! index loop fish
    integer :: k                ! index loop depth
    integer :: stdoutunit, stdlogunit, outunit
    integer :: init = 1
  
    integer :: layer_id_dpint   ! layer id at depth dp_int
    real :: hp_ingest_nmdz_dpint, hp_ingest_nlgz_dpint ! Depth integrated zooplankton ingestion from fish predation

    stdoutunit=stdout(); stdlogunit=stdlog()
    
    ! Affect value for each tracer: 
    fish(SF)%B = FEISTY%Sf_B(i,j)
    fish(SP)%B = FEISTY%Sp_B(i,j)
    fish(SD)%B = FEISTY%Sd_B(i,j)
    fish(MF)%B = FEISTY%Mf_B(i,j)
    fish(MP)%B = FEISTY%Mp_B(i,j)
    fish(MD)%B = FEISTY%Md_B(i,j)
    fish(LP)%B = FEISTY%Lp_B(i,j)
    fish(LD)%B = FEISTY%Ld_B(i,j)
    FEISTY%BE  = FEISTY%BE_B(i,j)
    
    ! get id of 100 m depth
    Do k = 1, nk
        if (zt(k) .le. dp_int) then ! BRZENSKI k used to be 'm'
            layer_id_dpint = k
        end if
    endDo
    
    !======================================================================!
    !                   Convertion from COBALT to FEISTY
    ! Converting zooplankton unit from [mol N m-2] to [gww m-2]
    FEISTY%Mz = SUM(med_zoo_N(1:layer_id_dpint) * dzt(1:layer_id_dpint)) * FEISTY%convers_Mz
    ! Check for Negative or nul values for zooplankton  
    if ( FEISTY%Mz .le. 0.0 ) then
        write(outunit,*) 'FEISTY Medium Zooplankton <= 0', FEISTY%Mz ,'!!! replacing by 0 ' 
        FEISTY%Mz = FEISTY%zero
    end if
    FEISTY%Lz = SUM(Lrg_zoo_N(1:layer_id_dpint) * dzt(1:layer_id_dpint)) * FEISTY%convers_Mz
    ! Check for Negative or nul values for zooplankton  
    if ( FEISTY%Lz .le. 0.0 ) then
        write(outunit,*) 'FEISTY Large Zooplankton <= 0', FEISTY%Lz ,' replacing by 0 !!!'
        FEISTY%Lz = FEISTY%zero
    end if

    ! Detritus convertion 
    FEISTY%det = det * FEISTY%convers_det   ! Convert in g ww m-2 d-1)
    
    ! Update fish time step based on actual cobalt time step (dt) from seconds to day
    ! Update fish time step based on actual cobalt time step (dt) from seconds to day
	Delta_t = dt/FEISTY%d2s

    !======================================================================!
    !                       test for negative values: 
    do m = 1, FEISTY%nFishGroup
        if (fish(m)%B .le. FEISTY%IC) then 
            fish(m)%B = FEISTY%IC
        end if  
    end do 
    
    ! should be equal to zero exept at last layer
    if (FEISTY%BE  .lt. FEISTY%IC) then
        FEISTY%BE = FEISTY%IC
    end if

    !:====================================================================== 
    ! Calcul effect of temperature on physiological rates 
    ! Temp      : Temperature in layer           [°C]
    ! ke        : coeff on encouter T-dep fn     [°C-1]
    ! kmet      : coeff on metabolic T-dep fn    [°C-1]
    ! Tcorr_e   : temperature correction for Encounter and Cmax
    ! Tcorr_met : temperature correction for metabolism
    ! cmax      : mass-specific maximum consumption          [d-1]
    ! V         : mass-specific Encounter rate               [m2 g−1 d−1]
    !:====================================================================== 
    
    ! Calcul average temperature in surface and take bottom temp
    Tp = SUM(Temp(1:layer_id_dpint)) / real(layer_id_dpint)
    Tp = Temp(1)  ! Temp at surface
    Tb = Temp(nk) ! Temp at bottom
    ! initialisation tpel: 
    tpel = (/1,1,1,1,1,0,1,0/)

    ! Calcul of biomass experience in pelagic for demersals by demersals
    biop = FEISTY%pref_Ld_Mf * fish(MF)%B + FEISTY%pref_Ld_Mp * fish(MD)%B
    biob = FEISTY%pref_Ld_Md * fish(MD)%B  + FEISTY%pref_Ld_BE * FEISTY%BE_B(i,j)

    if (zt(nk) < FEISTY%PI_be_cutoff) then  ! zt(nk) is the sea floor depth 
        tpel(FEISTY%nFishGroup) = biop / (biop + biob)
    else 
        tpel(FEISTY%nFishGroup) = 0.0
    end if 

    ! Temperature calculation for each fish: 
    do m = 1, FEISTY%nFishGroup
        Texp(m) = (Tp * tpel(m)) + (Tb*(1.0-tpel(m)))
        fish(m)%Tcorr_e = exp(FEISTY%ke * (Texp(m)-10.0))                                       ! save Temp effect on encounter rate and Cmax
        fish(m)%Tcorr_met = exp(FEISTY%kmet * (Texp(m)-10.0))                                   ! save Temp effect on met
        fish(m)%V = fish(m)%Tcorr_e * fish(m)%V_w                   ! update clearance rate with temp effect
        fish(m)%cmax = fish(m)%cmax_w * fish(m)%Tcorr_e             ! update cmax with temp effect
        fish(m)%met(i,j) = fish(m)%met_w * fish(m)%Tcorr_met        ! Temperature corrected metabolism
    end do 

    if (do_print_FEISTY_diagnostic) then 
        write(outunit,*) "Mz : ", FEISTY%Mz
        write(outunit,*) "Lz : ", FEISTY%Lz
        write(outunit,*) "Tp : ", Tp
        write(outunit,*) "Tb : ", Tb
        write(outunit,*) "det :", FEISTY%det
        write(outunit,*) "tpel : ", tpel
        write(outunit,*) "Texp : ", Texp
        write(outunit,*) "T_e : ", fish(m)%Tcorr_e
        write(outunit,*) "T_met : ", fish(m)%Tcorr_met
    endif 

    !:======================================================================
    ! Calculate the consumption for each group on zooplankton and fish 
    ! Test if consumption on zooplankton does not exceed the loss 
    ! to higher trophic level dZ
    ! f_       : feeding level on a specific group          [Ø]
    ! f        : total feeding level                        [Ø]
    ! pref_    : feeding preference for a specific group    [Ø]
    ! cons_    : consumption for a specific group           [d-1]
    ! cons     : total consumption                          [d-1]
    !:======================================================================

    ! If we use a functional type III response then we have to calculate the total resource encountered 
    ! dimensions: (8, 11)
        Resource(1) = FEISTY%Mz
        Resource(2) = FEISTY%Lz
        Resource(3) = FEISTY%BE
        do m = 1, FEISTY%nFishGroup
            Resource(3 + m) =  fish(m)%B
        end do 
        
        ! Make the resource as matrix for matrix calculation: 
        FEISTY%Resource_mat = spread(Resource, 1, 8)
        ! Calculate the matrix of prefered resource: 
        FEISTY%Resource_Pref = FEISTY%Resource_mat * FEISTY%Pref_mat

        ! Large demersals and 
        
        ! New Calculation of the feeding level ftot
        do m = 1, FEISTY%nFishGroup

            fish(m)%f_tot(i,j) = ((fish(m)%V * SUM(FEISTY%Resource_Pref(m, :)))**FEISTY%k_fct_tp)/ & 
                                   ((fish(m)%V * SUM(FEISTY%Resource_Pref(m, :)))**FEISTY%k_fct_tp + (k50 * fish(m)%cmax)**FEISTY%k_fct_tp)
            
            ! Estimate feeding level per resource based on proportion of resource over total resource encounter for each fish
            fish(m)%f_Mz = fish(m)%f_tot(i,j) * FEISTY%Resource_Pref(m, 1) / (SUM(FEISTY%Resource_Pref(m, :)) + FEISTY%eps)
            fish(m)%f_Lz = fish(m)%f_tot(i,j) * FEISTY%Resource_Pref(m, 2) / (SUM(FEISTY%Resource_Pref(m, :)) + FEISTY%eps)
            fish(m)%f_BE = fish(m)%f_tot(i,j) * FEISTY%Resource_Pref(m, 3) / (SUM(FEISTY%Resource_Pref(m, :)) + FEISTY%eps)
            fish(m)%f_Sf = fish(m)%f_tot(i,j) * FEISTY%Resource_Pref(m, 4) / (SUM(FEISTY%Resource_Pref(m, :)) + FEISTY%eps)
            fish(m)%f_Sp = fish(m)%f_tot(i,j) * FEISTY%Resource_Pref(m, 5) / (SUM(FEISTY%Resource_Pref(m, :)) + FEISTY%eps)
            fish(m)%f_Sd = fish(m)%f_tot(i,j) * FEISTY%Resource_Pref(m, 6) / (SUM(FEISTY%Resource_Pref(m, :)) + FEISTY%eps)
            fish(m)%f_Mf = fish(m)%f_tot(i,j) * FEISTY%Resource_Pref(m, 7) / (SUM(FEISTY%Resource_Pref(m, :)) + FEISTY%eps)
            fish(m)%f_Mp = fish(m)%f_tot(i,j) * FEISTY%Resource_Pref(m, 8) / (SUM(FEISTY%Resource_Pref(m, :)) + FEISTY%eps)
            fish(m)%f_Md = fish(m)%f_tot(i,j) * FEISTY%Resource_Pref(m, 9) / (SUM(FEISTY%Resource_Pref(m, :)) + FEISTY%eps)

            ! Calculate consumption: 
            fish(m)%cons_Mz(i,j) = fish(m)%f_Mz * fish(m)%cmax
            fish(m)%cons_Lz(i,j) = fish(m)%f_Lz * fish(m)%cmax
            fish(m)%cons_BE(i,j) = fish(m)%f_BE * fish(m)%cmax
            fish(m)%cons_Sf = fish(m)%f_Sf * fish(m)%cmax
            fish(m)%cons_Sp = fish(m)%f_Sp * fish(m)%cmax
            fish(m)%cons_Sd = fish(m)%f_Sd * fish(m)%cmax
            fish(m)%cons_Mf = fish(m)%f_Mf * fish(m)%cmax
            fish(m)%cons_Mp = fish(m)%f_Mp * fish(m)%cmax
            fish(m)%cons_Md = fish(m)%f_Md * fish(m)%cmax
            fish(m)%cons_f(i,j) = (fish(m)%f_Sf + fish(m)%f_Mf)* fish(m)%cmax
            fish(m)%cons_p(i,j) = (fish(m)%f_Sp + fish(m)%f_Mp)* fish(m)%cmax
            fish(m)%cons_d(i,j) = (fish(m)%f_Sd + fish(m)%f_Md)* fish(m)%cmax

            ! Calculate encounter rate:  enc_i = V * B * pref  = f_i*cmax / (1-f_tot) 
            fish(m)%enc_Mz(i,j) = fish(m)%V * FEISTY%Resource_Pref(m, 1)
            fish(m)%enc_Lz(i,j) = fish(m)%V * FEISTY%Resource_Pref(m, 2)
            fish(m)%enc_BE(i,j) = fish(m)%V * FEISTY%Resource_Pref(m, 3)
            fish(m)%enc_f(i,j)  = fish(m)%V * SUM(FEISTY%Resource_Pref(m, [4, 7]))
            fish(m)%enc_p(i,j)  = fish(m)%V * SUM(FEISTY%Resource_Pref(m, [5, 8, 10]))
            fish(m)%enc_d(i,j)  = fish(m)%V * SUM(FEISTY%Resource_Pref(m, [6, 9, 11]))

            ! Calculate total consumption: 
            fish(m)%cons_tot(i,j) = fish(m)%f_tot(i,j) * fish(m)%cmax
        end do  


    !:======================================================================
    ! Calculate fish available anergy (E_a),
    ! IF assimilated biomass lower than metabolic cost (i.e. E_a lt 0.0) 
    ! THEN consumption for each prey = 0.0  
    !:======================================================================
    do m = 1, FEISTY%nFishGroup
        fish(m)%E_A(i,j) = FEISTY%alpha * fish(m)%cons_tot(i,j) - fish(m)%met(i,j)     ! Calculation of available energy

        if (fish(m)%E_A(i,j) .le. FEISTY%zero) then 
            ! Calculate consumption: 
            fish(m)%cons_Mz(i,j) = FEISTY%zero
            fish(m)%cons_Lz(i,j) = FEISTY%zero
            fish(m)%cons_BE(i,j) = FEISTY%zero
            fish(m)%cons_Sf = FEISTY%zero
            fish(m)%cons_Sp = FEISTY%zero
            fish(m)%cons_Sd = FEISTY%zero
            fish(m)%cons_Mf = FEISTY%zero
            fish(m)%cons_Mp = FEISTY%zero
            fish(m)%cons_Md = FEISTY%zero
            fish(m)%cons_f(i,j) = FEISTY%zero
            fish(m)%cons_p(i,j) = FEISTY%zero
            fish(m)%cons_d(i,j) = FEISTY%zero

            ! Calculate encounter rate:  enc_i = V * B * pref  = f_i*cmax / (1-f_tot) 
            fish(m)%enc_Mz(i,j) = FEISTY%zero
            fish(m)%enc_Lz(i,j) = FEISTY%zero
            fish(m)%enc_BE(i,j) = FEISTY%zero
            fish(m)%enc_f(i,j)  = FEISTY%zero
            fish(m)%enc_p(i,j)  = FEISTY%zero
            fish(m)%enc_d(i,j)  = FEISTY%zero

            ! Calculate total consumption: 
            fish(m)%cons_tot(i,j) = FEISTY%zero
        end if
    end do 
    
    !:======================================================================
    ! Calculate the mortality for fish functional group 
    ! Fishing mortality is assumed constant and nul
    ! mu_p : Predation from fish      [d-1]
    ! mu_f : Fishing mortality ( = 0) [d-1]
    ! mu_a : Natural mortality        [d-1]
    !:======================================================================

    ! Depth integrated Fraction of zooplankton biomass consumed :----------------------------------------
    ! Calcul total consumption (integrated) for each Zooplankton group: [g WW m-2 d-1]
    hp_ingest_nmdz_dpint = (fish(SF)%cons_Mz(i,j) * fish(SF)%B + fish(SP)%cons_Mz(i,j) * fish(SP)%B + & 
                fish(SD)%cons_Mz(i,j) * fish(SD)%B + fish(MF)%cons_Mz(i,j) * fish(MF)%B + &
                fish(MP)%cons_Mz(i,j) * fish(MP)%B)  
    hp_ingest_nlgz_dpint = (fish(MF)%cons_Lz(i,j) * fish(MF)%B + fish(MP)%cons_Lz(i,j) * fish(MP)%B)
	
	! Converting zooplankton consumption back from [g WW m-2 d-1] to [mol N kg s-1] to be unsed in COBALT
	hp_ingest_nmdz_dpint = hp_ingest_nmdz_dpint / (FEISTY%convers_Mz * FEISTY%d2s)
	hp_ingest_nlgz_dpint = hp_ingest_nlgz_dpint / (FEISTY%convers_Mz * FEISTY%d2s)

    ! Calculation of the hight trophic level predation on zooplankton at every depth: 
    ! integrated zooplankton biomass has dimension of [g WW C m-2]
    ! med_zoo_N(k) and Lrg_zoo_N(k) are in [mol N kg]
    if (FEISTY%Mz .le. FEISTY%zero) then 
        hp_ingest_nmdz(1:layer_id_dpint) = FEISTY%zero
    else 
        Do k = 1, layer_id_dpint
            hp_ingest_nmdz(k) = hp_ingest_nmdz_dpint * med_zoo_N(k) * FEISTY%convers_Mz * (1.00/(FEISTY%Mz + FEISTY%eps)) * (1.00/dzt(k))
        endDo
    endif
    if (FEISTY%Lz .le. FEISTY%zero) then 
        hp_ingest_nlgz(1:layer_id_dpint) = FEISTY%zero
    else 
        Do k = 1, layer_id_dpint
            hp_ingest_nlgz(k) = hp_ingest_nlgz_dpint * Lrg_zoo_N(k) * FEISTY%convers_Mz * (1.00/(FEISTY%Lz + FEISTY%eps)) * (1.00/dzt(k))
        endDo
    endif

    ! predation only in the first 100m depth [mol N kg s-1]
    hp_ingest_nmdz((layer_id_dpint + int(1)): nk) = FEISTY%zero
    hp_ingest_nlgz((layer_id_dpint + int(1)): nk) = FEISTY%zero

    ! Calcul Predation mortality fish : -----------------------------------------------
    ! mu_p [m-2 d-1]
    fish(SF)%mu_p(i,j) = (fish(MP)%cons_Sf * fish(MP)%B + fish(MF)%cons_Sf * fish(MF)%B) / fish(SF)%B
    fish(SP)%mu_p(i,j) = (fish(MP)%cons_Sp * fish(MP)%B + fish(MF)%cons_Sp * fish(MF)%B) / fish(SP)%B
    fish(SD)%mu_p(i,j) = (fish(MP)%cons_Sd * fish(MP)%B + fish(MF)%cons_Sd * fish(MF)%B) / fish(SD)%B
    fish(MF)%mu_p(i,j) = (fish(LP)%cons_Mf * fish(LP)%B + fish(LD)%cons_Mf * fish(LD)%B) / fish(MF)%B
    fish(MP)%mu_p(i,j) = (fish(LP)%cons_Mp * fish(LP)%B + fish(LD)%cons_Mp * fish(LD)%B) / fish(MP)%B
    fish(MD)%mu_p(i,j) = (fish(LP)%cons_Md * fish(LP)%B + fish(LD)%cons_Md * fish(LD)%B) / fish(MD)%B
    fish(LP)%mu_p(i,j) = 0
    fish(LD)%mu_p(i,j) = 0

    ! Calcul Fishing mortality! ----------------------------------------------
    ! Small fish are not fished
    ! Medium forage are fished at 1 
    ! Large fish are fished at 1 
    !  ------------------------------------------------------------------------
    fish(MF)%mu_f = FEISTY%Frate * FEISTY%Aselct
    fish(MP)%mu_f = FEISTY%Frate * FEISTY%Jselct * FEISTY%Aselct
    fish(MD)%mu_f = FEISTY%Frate * FEISTY%Jselct * FEISTY%Aselct
    fish(LP)%mu_f = FEISTY%Frate * FEISTY%Aselct
    fish(LD)%mu_f = FEISTY%Frate * FEISTY%Aselct
	
	!:======================================================================
    ! Calculate of : 
    ! yield        : Fishing Yield                                     [d-1] 
    ! mu           : Tot mortality                                     [d-1] 
    ! met          : Metabolic loss                                    [d-1] 
    ! met_w        : size-based Metabolic loss                         [d-1] 
    ! tcorr_met    : temperature correction                            []
    ! alpha        : Assimilation efficiency                           []
    !:======================================================================
    do m = 1, FEISTY%nFishGroup
        fish(m)%yield(i,j) = fish(m)%mu_f * fish(m)%B                                      ! Fishing Yield [g ww m-2 d-1]
        fish(m)%mu = fish(m)%mu_p(i,j) + fish(m)%mu_a + fish(m)%mu_f                       ! Total mortality 
        fish(m)%prod(i,j) = max(fish(m)%E_A(i,j) * fish(m)%B, FEISTY%zero)               ! Productivity (E_a * Biomass) if E_a < 0 prod = 0 
    end do


    !:======================================================================
    ! calcul the flux of biomass out of a size class for each fish group  
    !:======================================================================
    fish(SF)%Fout(i,j) = ((FEISTY%kappa_l * fish(SF)%E_A(i,j)) - fish(SF)%mu ) /&
        (1 - (FEISTY%Z_s ** (1 - (fish(SF)%mu / (FEISTY%kappa_l * fish(SF)%E_A(i,j)+ FEISTY%eps)))) + FEISTY%eps)
    fish(SP)%Fout(i,j) = ((FEISTY%kappa_l * fish(SP)%E_A(i,j)) - fish(SP)%mu ) /&
        (1 - (FEISTY%Z_s ** (1 - (fish(SP)%mu / (FEISTY%kappa_l * fish(SP)%E_A(i,j)+ FEISTY%eps)))) + FEISTY%eps)
    fish(SD)%Fout(i,j) = ((FEISTY%kappa_l * fish(SD)%E_A(i,j)) - fish(SD)%mu ) /&
        (1 - (FEISTY%Z_s ** (1 - (fish(SD)%mu / (FEISTY%kappa_l * fish(SD)%E_A(i,j)+ FEISTY%eps)))) + FEISTY%eps)
    fish(MF)%Fout(i,j) = ((FEISTY%kappa_a * fish(MF)%E_A(i,j)) - fish(MF)%mu ) /&
        (1 - (FEISTY%Z_m ** (1 - (fish(MF)%mu / (FEISTY%kappa_a * fish(MF)%E_A(i,j)+ FEISTY%eps)))) + FEISTY%eps)
    fish(MP)%Fout(i,j) = ((FEISTY%kappa_j * fish(MP)%E_A(i,j)) - fish(MP)%mu ) /&
        (1 - (FEISTY%Z_m ** (1 - (fish(MP)%mu / (FEISTY%kappa_j * fish(MP)%E_A(i,j)+ FEISTY%eps)))) + FEISTY%eps)
    fish(MD)%Fout(i,j) = ((FEISTY%kappa_j * fish(MD)%E_A(i,j)) - fish(MD)%mu ) /&
        (1 - (FEISTY%Z_m ** (1 - (fish(MD)%mu / (FEISTY%kappa_j * fish(MD)%E_A(i,j)+ FEISTY%eps)))) + FEISTY%eps)
    fish(LP)%Fout(i,j) = ((FEISTY%kappa_a * fish(LP)%E_A(i,j)) - fish(LP)%mu ) /&
        (1 - (FEISTY%Z_l ** (1 - (fish(LP)%mu / (FEISTY%kappa_a * fish(LP)%E_A(i,j)+ FEISTY%eps)))) + FEISTY%eps)
    fish(LD)%Fout(i,j) = ((FEISTY%kappa_a * fish(LD)%E_A(i,j)) - fish(LD)%mu ) /&
        (1 - (FEISTY%Z_l ** (1 - (fish(LD)%mu / (FEISTY%kappa_a * fish(LD)%E_A(i,j)+ FEISTY%eps)))) + FEISTY%eps)
    ! If Fout is higher than E_a take E_a, and 0 is negative: 
    do m = 1, FEISTY%nFishGroup
        fish(m)%Fout(i,j) = max(min(fish(m)%Fout(i,j), fish(m)%E_A(i,j)), FEISTY%zero)
    end do 

    !:======================================================================
    ! Calcul the reproductive flux of biomass 
    ! rho   : rate (of biomass) invested in reproduction after reproduction loss [m-2 d-1]
    ! eps_R   : Reproduction efficiency 
    ! We DO NOT assum that the biomass that is going out of the last size class (Adult)
    ! is converted to reproduction to account for a fraction of individual dying after 
    ! reproduction. 
    !:======================================================================
    ! Only Medium forage, large pelagic and demersal reproduce: 
    fish(MF)%rho(i,j) = max((1.0 - FEISTY%kappa_a) * fish(MF)%E_A(i,j) + fish(MF)%Fout(i,j), FEISTY%zero)
    fish(LP)%rho(i,j) = max((1.0 - FEISTY%kappa_a) * fish(LP)%E_A(i,j) + fish(LP)%Fout(i,j), FEISTY%zero)
    fish(LD)%rho(i,j) = max((1.0 - FEISTY%kappa_a) * fish(LD)%E_A(i,j) + fish(LD)%Fout(i,j), FEISTY%zero)

    ! Fout for Adult are set up to 0: (sub_rep function in matlab)
    fish(MF)%Fout(i,j) = 0 
    fish(LP)%Fout(i,j) = 0
    fish(LD)%Fout(i,j) = 0	

    !:======================================================================
    ! Update the prognostics tracer fields via their pointers.
    ! Prognostic tracers are updated after calculation of the derivative. 
    !:======================================================================

    ! Calcul derivative for each group : -----------------------------------------
    
    ! Small size (no loss from reproduction)
    fish(SF)%dBdt_fish(i,j) = FEISTY%eps_R * fish(MF)%rho(i,j) * fish(MF)%B + (fish(SF)%E_A(i,j) - fish(SF)%Fout(i,j) - fish(SF)%mu) * fish(SF)%B
    fish(SP)%dBdt_fish(i,j) = FEISTY%eps_R * fish(LP)%rho(i,j) * fish(LP)%B + (fish(SP)%E_A(i,j) - fish(SP)%Fout(i,j) - fish(SP)%mu) * fish(SP)%B
    fish(SD)%dBdt_fish(i,j) = FEISTY%eps_R * fish(LD)%rho(i,j) * fish(LD)%B + (fish(SD)%E_A(i,j) - fish(SD)%Fout(i,j) - fish(SD)%mu) * fish(SD)%B  
    
    ! Medium size (reproduction loss for Mf)
    fish(MF)%dBdt_fish(i,j) = fish(SF)%Fout(i,j) * fish(SF)%B + (fish(MF)%E_A(i,j) - fish(MF)%rho(i,j) - fish(MF)%mu) * fish(MF)%B 
    fish(MP)%dBdt_fish(i,j) = fish(SP)%Fout(i,j) * fish(SP)%B + (fish(MP)%E_A(i,j) - fish(MP)%Fout(i,j)  - fish(MP)%mu) * fish(MP)%B 
    fish(MD)%dBdt_fish(i,j) = fish(SD)%Fout(i,j) * fish(SD)%B + (fish(MD)%E_A(i,j) - fish(MD)%Fout(i,j)  - fish(MD)%mu) * fish(MD)%B 

    ! Large fish (reproduction Fout = 0) 
    fish(LP)%dBdt_fish(i,j) = fish(MP)%Fout(i,j) * fish(MP)%B + (fish(LP)%E_A(i,j) - fish(LP)%rho(i,j) - fish(LP)%mu) * fish(LP)%B
    fish(LD)%dBdt_fish(i,j) = fish(MD)%Fout(i,j) * fish(MD)%B + (fish(LD)%E_A(i,j) - fish(LD)%rho(i,j) - fish(LD)%mu) * fish(LD)%B 

    !:======================================================================
    ! Calcul the Benthic biomass from detritus flux to benthic 
    ! Classic logistic growth rate
    ! The calculation has to be done after the derivative have been calculated 
    ! for each fish group ! 
    !:======================================================================
    ! This%BE%B          : Benthic biomass 
    ! Bent_eff =  0.075  : Benthic Efficiency from detritus to benthic biomass
    ! CC = 80            : Carring Capacity for benthic chemostat
    ! FEISTY%BE          : former benthic biomass
    !:======================================================================
    pred_BE = fish(MD)%cons_BE(i,j) * FEISTY%Md_B(i,j) + fish(LD)%cons_BE(i,j) * FEISTY%Ld_B(i,j)
    r_BE = FEISTY%Bent_eff * FEISTY%det / (FEISTY%BE + FEISTY%eps)
    FEISTY%dBdt_BE(i,j) = (r_BE * FEISTY%BE * (1 - FEISTY%BE/FEISTY%CC) - pred_BE) 

    ! Print Fish outputs at second time step (tau =2):
    if (do_print_FEISTY_diagnostic) then 
        
        write (outunit,*)  '------------ input for FEISTY ------------'
        write (outunit,*)  'depth =                   ', zt(nk)
        write (outunit,*)  'Temperature               ', Temp
        write (outunit,*)  'small zooplankton biomass ', med_zoo_N * FEISTY%convers_Mz
        write (outunit,*)  'large zooplankton biomass ', Lrg_zoo_N * FEISTY%convers_Mz
        write (outunit,*)  '-------------- FEISTY output --------------'

        write (outunit,*)  '-------------- FEISTY Biomass --------------'
        do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%B
        end do 
        write (outunit,*)  "BE : ", FEISTY%BE


        write (outunit,*)  '-------------- FEISTY derivative --------------'
        do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%dBdt_fish(i,j)
        end do 
        write (outunit,*)  FEISTY%dBdt_BE(i,j) 

        write (outunit,*)  '-------------- Non diagnostic parameters --------------'

        write (outunit,*)  '-------------- Benthic parameters --------------'
        write (outunit,*)  'r_BE : ', r_BE
        write (outunit,*)  'pred_BE : ', pred_BE

        if (FunctRspons_typeIII) then 
            write (outunit,*)  '-------------- Functional type matrixes --------------'
            
            write (outunit,*)  '-------------- Pref_mat --------------'
            write (outunit,*) "Pref_mat dimensions:", SHAPE(FEISTY%Pref_mat)
            write (outunit,*) "Pref_mat values: "
            do m = 1, FEISTY%nFishGroup
                write (outunit, '(11(F6.2, 1X))') FEISTY%Pref_mat
            end do

            write (outunit,*)  '-------------- Resource_mat --------------'
            write (outunit,*) "Resource_mat dimensions:", SHAPE(FEISTY%Resource_mat)
            write (outunit,*) "Resource_mat values: "
            do m = 1, FEISTY%nFishGroup
                write (outunit, '(11(F6.2, 1X))') FEISTY%Resource_mat
            end do 

            write (outunit,*)  '-------------- Resource_Pref --------------'
            write (outunit,*) "Resource_Pref dimensions:", SHAPE(FEISTY%Pref_mat)
            write (outunit,*) "Resource_Pref values: "
            do m = 1, FEISTY%nFishGroup
                write (outunit, '(11(F6.2, 1X))') FEISTY%Resource_Pref
            end do 
            FEISTY%Resource_mat = spread(Resource, 1, 8)

        ! Calculate the matrix of prefered resource: 
        FEISTY%Resource_Pref = FEISTY%Resource_mat * FEISTY%Pref_mat
        end if 

        write (outunit,*)  '-------------- cmax  --------------'
        do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%cmax
        end do 

        write (outunit,*)  '-------------- V  --------------'
        do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%V
        end do

        write (outunit,*)  '-------------- Tcorr_met --------------'
        do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%Tcorr_met
        end do

        write (outunit,*)  '-------------- Tcorr_e  --------------'
        do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%Tcorr_e
        end do

        write (outunit,*)  '-------------- Diagnostics --------------'
        write (outunit,*)  '-------------- FEISTY met  --------------'
        do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%met(i,j)
        end do 
        write (outunit,*)  '-------------- FEISTY enc_Mz  --------------'
        do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%enc_Mz(i,j)
        end do 

        write (outunit,*)  '-------------- FEISTY enc_Lz  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%enc_Lz(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY enc_f  --------------'
        do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%enc_f(i,j)
        end do 
    	
        write (outunit,*)  '-------------- FEISTY enc_p  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%enc_p(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY enc_d  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%enc_d(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY enc_BE  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%enc_BE(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY cons_Mz  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%cons_Mz(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY cons_Lz  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%cons_Lz(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY cons_f  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%cons_f(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY cons_p  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%cons_p(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY cons_d  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%cons_d(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY cons_BE  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%cons_BE(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY cons_tot  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%cons_tot(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY f_tot  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%f_tot(i,j)
        end do 
        
        write (outunit,*)  '-------------- FEISTY mu_p  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%mu_p(i,j)
        end do 
       
        write (outunit,*)  '-------------- FEISTY  E_A  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%E_A(i,j)
        end do 
       
        write (outunit,*)  '-------------- FEISTY Productivity = E_A* Biomass  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%prod(i,j)
        end do 

        write (outunit,*)  '-------------- FEISTY Fout  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%Fout(i,j)
        end do 

        write (outunit,*)  '-------------- FEISTY rho  --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%rho(i,j)
        end do 
         
        write (outunit,*)  '-------------- FEISTY yield = nu_F * Biomass --------------'
    	do m = 1, FEISTY%nFishGroup
            write (outunit,*)  fish(m)%yield(i,j)
        end do 

        STOP

    end if

end subroutine generic_FEISTY_fish_update_from_source


!#######################################################################
! <SUBROUTINE NAME="generic_FEISTY_update_pointer">
!
! <DESCRIPTION>
!   Calculate new Fish biomass from pointers. 
!   The grid_tmask(:,:,1)(i,j) might be unecessary for fish.
! 
! </DESCRIPTION>
subroutine generic_FEISTY_update_pointer(i, j, tau, dt)
    integer, intent(in) :: i, j, tau
    real,    intent(in) :: dt
    real                :: Delta_t
    ! FEISTY%d2s: Conversion from Day to second
    ! FEISTY dBdt, variation of fish per time, has a dt in day. However, COBALT runs un unit of second (dt)
    ! Therefore we need to convert FEISTY derivativve from d to second, i.e., 
    ! dBdt in g ww C d-1 in g ww C s-1 
    Delta_t = dt / FEISTY%d2s

    FEISTY%p_Sf_B(i,j,tau) = FEISTY%p_Sf_B(i,j,tau) +  fish(SF)%dBdt_fish(i,j) * Delta_t 
    FEISTY%p_Sp_B(i,j,tau) = FEISTY%p_Sp_B(i,j,tau) +  fish(SP)%dBdt_fish(i,j) * Delta_t 
    FEISTY%p_Sd_B(i,j,tau) = FEISTY%p_Sd_B(i,j,tau) +  fish(SD)%dBdt_fish(i,j) * Delta_t 
    FEISTY%p_Mf_B(i,j,tau) = FEISTY%p_Mf_B(i,j,tau) +  fish(MF)%dBdt_fish(i,j) * Delta_t 
    FEISTY%p_Mp_B(i,j,tau) = FEISTY%p_Mp_B(i,j,tau) +  fish(MP)%dBdt_fish(i,j) * Delta_t 
    FEISTY%p_Md_B(i,j,tau) = FEISTY%p_Md_B(i,j,tau) +  fish(MD)%dBdt_fish(i,j) * Delta_t 
    FEISTY%p_Lp_B(i,j,tau) = FEISTY%p_Lp_B(i,j,tau) +  fish(LP)%dBdt_fish(i,j) * Delta_t 
    FEISTY%p_Ld_B(i,j,tau) = FEISTY%p_Ld_B(i,j,tau) +  fish(LD)%dBdt_fish(i,j) * Delta_t 
    FEISTY%p_BE_B(i,j,tau) = FEISTY%p_BE_B(i,j,tau) +  FEISTY%dBdt_BE(i,j)     * Delta_t 

end subroutine generic_FEISTY_update_pointer


!#######################################################################
! <SUBROUTINE NAME="generic_FEISTY_send_diagnostic_data">
!
! <DESCRIPTION>
!   Save FEISTY diagnostics 
! 
! </DESCRIPTION>
subroutine generic_FEISTY_send_diagnostic_data(model_time)
    type(time_type),     intent(in) :: model_time
    real, dimension(:,:,:), pointer :: grid_tmask
    integer :: isc,iec,jsc,jec,isd,ied,jsd,jed,nk,ntau, m
    logical :: used

    call g_tracer_get_common(isc,iec,jsc,jec,isd,ied,jsd,jed,nk,ntau,grid_tmask=grid_tmask) 

    do m = 1, FEISTY%nFishGroup
        if (fish(m)%id_met .gt. 0)             &
            used = g_send_data(fish(m)%id_met, fish(m)%met,           &
            model_time, rmask = grid_tmask(:,:,1),&
            is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)

        if (fish(m)%id_enc_Mz .gt. 0)          & 
            used = g_send_data(fish(m)%id_enc_Mz, fish(m)%enc_Mz,           & 
            model_time, rmask = grid_tmask(:,:,1),& 
            is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_enc_Mz .gt. 0)          &
            used = g_send_data(fish(m)%id_enc_Mz, fish(m)%enc_Mz ,           &
            model_time, rmask = grid_tmask(:,:,1),&
            is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)

        if (fish(m)%id_enc_Lz .gt. 0)          &
                    used = g_send_data(fish(m)%id_enc_Lz, fish(m)%enc_Lz ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)

        if (fish(m)%id_enc_f .gt. 0)          &
                    used = g_send_data(fish(m)%id_enc_f, fish(m)%enc_f ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)

        if (fish(m)%id_enc_p .gt. 0)          &
                    used = g_send_data(fish(m)%id_enc_p, fish(m)%enc_p ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_enc_d .gt. 0)          &
                    used = g_send_data(fish(m)%id_enc_d, fish(m)%enc_d ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_enc_BE .gt. 0)          &
                    used = g_send_data(fish(m)%id_enc_BE, fish(m)%enc_BE ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_cons_Mz .gt. 0)          &
                    used = g_send_data(fish(m)%id_cons_Mz, fish(m)%cons_Mz ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_cons_Lz .gt. 0)          &
                    used = g_send_data(fish(m)%id_cons_Lz, fish(m)%cons_Lz ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
                    if (fish(m)%id_cons_f .gt. 0)          &
                    used = g_send_data(fish(m)%id_cons_f, fish(m)%cons_f ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_cons_p .gt. 0)          &
                    used = g_send_data(fish(m)%id_cons_p, fish(m)%cons_p ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_cons_d .gt. 0)          &
                    used = g_send_data(fish(m)%id_cons_d, fish(m)%cons_d ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_cons_BE .gt. 0)          &
                    used = g_send_data(fish(m)%id_cons_BE, fish(m)%cons_BE ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_cons_tot .gt. 0)          &
                    used = g_send_data(fish(m)%id_cons_tot, fish(m)%cons_tot ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)

        if (fish(m)%id_f_tot .gt. 0)          &
                    used = g_send_data(fish(m)%id_f_tot, fish(m)%f_tot ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_mu_p .gt. 0)          &
                    used = g_send_data(fish(m)%id_mu_p, fish(m)%mu_p ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_E_A .gt. 0)          &
                    used = g_send_data(fish(m)%id_E_A, fish(m)%E_A ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_prod .gt. 0)          &
                    used = g_send_data(fish(m)%id_prod, fish(m)%prod ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_Fout .gt. 0)          &
                    used = g_send_data(fish(m)%id_Fout, fish(m)%Fout ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_rho .gt. 0)          &
                    used = g_send_data(fish(m)%id_rho, fish(m)%rho ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)
        
        if (fish(m)%id_yield .gt. 0)          &
                    used = g_send_data(fish(m)%id_yield, fish(m)%yield ,           &
                    model_time, rmask = grid_tmask(:,:,1),&
                    is_in=isc, js_in=jsc, ie_in=iec, je_in=jec)

    end do

end subroutine generic_FEISTY_send_diagnostic_data

end module generic_FEISTY


