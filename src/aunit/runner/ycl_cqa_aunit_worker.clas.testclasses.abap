CLASS ltc_aunit DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA mo_cut TYPE REF TO ycl_cqa_aunit_worker.
    METHODS setup.
    METHODS build_object_list
      RETURNING
        VALUE(rt_object_list) TYPE yif_cqa_aunit_package_query=>tt_development_elements.

    METHODS test_one_class FOR TESTING.
    METHODS build_unit_test_table FOR TESTING.

ENDCLASS.


CLASS ltc_aunit IMPLEMENTATION.

  METHOD setup.

    mo_cut = NEW #( ).

  ENDMETHOD.

  METHOD build_object_list.

    DATA(lo_package) = cl_package=>s_get_package( 'ZFI_EK_GF' ).
    cl_pak_dev_element=>factory2(
        EXPORTING i_dev_elem_type = 'CLAS' i_dev_elem_key = 'ZCL_GF_ERMITTLUNG'
        IMPORTING e_dev_element = DATA(lo_element) ).
    rt_object_list = VALUE #( ( element = lo_element
                                package = lo_package ) ).

    lo_package = cl_package=>s_get_package( 'ZFI_EK_ALINK' ).
    cl_pak_dev_element=>factory2(
      EXPORTING
       i_dev_elem_type  = 'CLAS'
       i_dev_elem_key   = 'ZCL_EK_ALINK'
      IMPORTING
        e_dev_element    = lo_element ).
    rt_object_list = VALUE #( BASE rt_object_list ( element = lo_element
                                                    package = lo_package ) ).

  ENDMETHOD.

  METHOD test_one_class.

    DATA(lo_aunit_cvrg_preparation) = NEW ycl_cqa_aunit_cvrg_preparation( ).
    DATA(lo_aunit_rslt_preparation) = NEW ycl_cqa_aunit_rslt_preparation( ).
    DATA(lt_object_list) = build_object_list( ).
    TRY.
        mo_cut->yif_cqa_aunit_worker~run_aunit_kpi(
            it_object_list      = lt_object_list
            io_aunit_cvrg_preparation = lo_aunit_cvrg_preparation
            io_aunit_rslt_preparation     = lo_aunit_rslt_preparation
        ).
      CATCH cx_scv_execution_error INTO DATA(lx_execution_error).
    ENDTRY.

    cl_abap_unit_assert=>assert_not_bound(
        act              = lx_execution_error
        msg              = |Es sollte keine Exception aufgetreten sein.|
    ).

    lo_aunit_cvrg_preparation->set_object_list( lt_object_list ).

    TRY.
        DATA(lo_crvg_result) = lo_aunit_cvrg_preparation->if_aucv_cvrg_rslt_provider~build_coverage_result( ).
      CATCH cx_scv_execution_error.
      CATCH cx_scv_call_error.
    ENDTRY.

    DATA(lt_result_list) = lo_aunit_cvrg_preparation->get_result_list( ).

    DATA(lo_list_result) = lt_result_list[ 1 ].
    DATA(lv_check_name) = cl_aunit_prog_info=>tadir_to_progname(
        obj_type = 'CLAS'
        obj_name = 'ZCL_GF_ERMITTLUNG' ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'Der Name des Objektes sollte ZCL_GF_ERMITTLUNG sein.'
        exp = lv_check_name
        act = lo_list_result->get_name( ) ).

    DATA(lo_coverage) = lo_list_result->get_coverage( i_type = ce_scv_coverage_type=>statement ).

    cl_abap_unit_assert=>assert_equals(
        msg = 'Die Azahl Exceuted sollte 83 sein.'
        exp = 83
        act = lo_coverage->get_executed( ) ).

  ENDMETHOD.

  METHOD build_unit_test_table.

    DATA(lt_object_list) = build_object_list( ).

    cl_abap_unit_assert=>assert_equals(
    msg = 'Die Tabelle sollte x Zeilen enthalten.'
    exp = 2
    act = lines( mo_cut->get_unit_tests_for_objects( lt_object_list ) ) ).

  ENDMETHOD.

ENDCLASS.
