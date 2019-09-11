CLASS ltc_aunit_runner DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS get_aunit_colletion_4_package FOR TESTING .
ENDCLASS.


CLASS ltc_aunit_runner IMPLEMENTATION.

  METHOD get_aunit_colletion_4_package.

    DATA(lo_cut) = NEW ycl_cqa_aunit_runner_handler( ).

    DATA(lt_package_range) = VALUE scompaksel( ( sign = 'I' option = 'EQ' low = 'ZFI_EK_GF' ) ).
    TRY.
        lo_cut->run( lt_package_range ).
      CATCH cx_scv_execution_error INTO DATA(lx_execution_error).
    ENDTRY.


    cl_abap_unit_assert=>assert_bound(
        act = lo_cut->get_data_provider( )
        msg = |Es sollte eine Collection zurueck geliefert werden|
    ).

    cl_abap_unit_assert=>assert_not_bound(
        act              = lx_execution_error
        msg              = |Es sollte keine Exception aufgetreten sein.|
    ).

  ENDMETHOD.

ENDCLASS.
