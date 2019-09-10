CLASS ltc_aunit_result_stub DEFINITION FINAL FOR TESTING
  INHERITING FROM ycl_cqa_aunit_rslt_preparation
  DURATION SHORT
  RISK LEVEL HARMLESS.


ENDCLASS.


CLASS ltc_aunit_result_stub IMPLEMENTATION.
ENDCLASS.

CLASS ltd_code_cvrg_grabber_stub DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PUBLIC SECTION.
    INTERFACES if_aucv_cvrg_rslt_provider.

ENDCLASS.

CLASS ltd_code_cvrg_grabber_stub IMPLEMENTATION.

  METHOD if_aucv_cvrg_rslt_provider~build_coverage_result.

  ENDMETHOD.

ENDCLASS.


CLASS ltc_result_collector DEFINITION FINAL FOR TESTING
  DURATION MEDIUM
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_sut TYPE REF TO ycl_cqa_aunit_data_provider.

    METHODS setup RAISING cx_static_check.
    METHODS get_all_test_results FOR TESTING.
ENDCLASS.


CLASS ltc_result_collector IMPLEMENTATION.

  METHOD setup.

    DATA(lt_object_list) = NEW ycl_cqa_aunit_package_query( )->yif_cqa_aunit_package_query~get_all_elements_for_package( VALUE #( ( sign = 'I' option = 'EQ' low = 'ZFI_EK' ) ) ).

    DATA(lo_aunit_rslt_preparation) = NEW ycl_cqa_aunit_rslt_preparation( ).
    DATA(lo_aunit_cvrg_preparation) = NEW ycl_cqa_aunit_cvrg_preparation( ).

    DATA(lo_worker) = CAST yif_cqa_aunit_worker( NEW ycl_cqa_aunit_worker( ) ).
    lo_worker->run_aunit_kpi( it_object_list      = lt_object_list
                              io_aunit_cvrg_preparation = lo_aunit_cvrg_preparation
                              io_aunit_rslt_preparation     = lo_aunit_rslt_preparation ).

    mo_sut = NEW ycl_cqa_aunit_data_provider(
                    io_aunit_rslt_preparation = lo_aunit_rslt_preparation
                    io_aunit_cvrg_preparation = lo_aunit_cvrg_preparation
                    it_development_elements = lt_object_list
                  ).
  ENDMETHOD.

  METHOD get_all_test_results.
    DATA(ls_expected_result) = VALUE yif_cqa_aunit_dao_in=>ts_aunit_result(
                                              execution_date = sy-datum
                                              execution_time = sy-uzeit
                                              package_name = 'ZFI_EK_GF'
                                              object_name = 'ZCL_GF_ERMITTLUNG'
                                              object_type = 'CLAS'
                                              tests_total = 11
                                              tests_failed = 0
                                              cov_branch_total = 39
                                              cov_branch_exec = 35
                                              cov_proc_total = 15
                                              cov_proc_exec = 15
                                              cov_statement_total = 88
                                              cov_statement_exec = 84
                                              ).

    cl_abap_unit_assert=>assert_table_contains(
        line             = ls_expected_result
        table            = mo_sut->get_all_test_results( )
    ).
  ENDMETHOD.

ENDCLASS.
