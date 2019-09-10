CLASS ltc_code_coverage_grabber DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS get_object_for_coverage FOR TESTING.
ENDCLASS.


CLASS ltc_code_coverage_grabber IMPLEMENTATION.

  METHOD get_object_for_coverage.

    DATA(lo_cut) = NEW ycl_cqa_aunit_cvrg_preparation( ).

    DATA(lo_worker) = NEW ycl_cqa_aunit_worker( ).

    DATA(lo_package) = cl_package=>s_get_package( 'ZFI_EK_GF' ).
    cl_pak_dev_element=>factory2(
        EXPORTING i_dev_elem_type = 'CLAS' i_dev_elem_key = 'ZCL_GF_ERMITTLUNG'
        IMPORTING e_dev_element = DATA(lo_element) ).

    DATA(lt_object_list) = VALUE yif_cqa_aunit_package_query=>tt_development_elements(
                                   ( element = lo_element
                                     package = lo_package ) ).

    DATA(lo_aunit_rslt)      = NEW ycl_cqa_aunit_rslt_preparation( ).

    TRY.
        lo_worker->yif_cqa_aunit_worker~run_aunit_kpi(
                it_object_list      = lt_object_list
                io_aunit_cvrg_preparation = lo_cut
                io_aunit_rslt_preparation     = lo_aunit_rslt
        ).
      CATCH cx_scv_execution_error INTO DATA(lx_execution_error).
    ENDTRY.

    cl_abap_unit_assert=>assert_not_bound(
        act              = lx_execution_error
        msg              = |Es sollte keine Exception aufgetreten sein.|
    ).

    lo_cut->set_object_list( lt_object_list ).

    TRY.
        DATA(lo_crvg_result) = lo_cut->if_aucv_cvrg_rslt_provider~build_coverage_result( ).
      CATCH cx_scv_execution_error.
      CATCH cx_scv_call_error.
    ENDTRY.

    DATA(lv_check_name) = cl_aunit_prog_info=>tadir_to_progname(
        obj_type = 'CLAS'
        obj_name = 'ZCL_GF_ERMITTLUNG' ).

    DATA(lo_result_object) = lo_cut->get_result_object( lv_check_name ).

    DATA(lo_branch) = lo_result_object->get_coverage( ce_scv_coverage_type=>branch ).

    cl_abap_unit_assert=>assert_bound(
        act              = lo_result_object
        msg              = |An Object should be returned|
    ).

  ENDMETHOD.

ENDCLASS.
