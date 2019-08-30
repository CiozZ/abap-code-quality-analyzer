*"* use this source file for your ABAP unit test classes
CLASS ltc_service_api DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO ycl_cqa_aunit_service_api.
    METHODS:
      setup.
    METHODS:
      run_without_package FOR TESTING,
      run_with_invalid_date FOR TESTING,
      run_with_test_double FOR TESTING RAISING ycx_cqa_aunit_service_api.
    METHODS:
      get_expected_result
        IMPORTING iv_exec_date     TYPE d
        RETURNING VALUE(rt_result) TYPE ycqa_aunit_ext_resp_t.
ENDCLASS.


CLASS ltc_service_api IMPLEMENTATION.

  METHOD setup.
    DATA(lo_persistence) = NEW lcl_persistence_test_double( ).
    CREATE OBJECT mo_cut EXPORTING io_persistence = lo_persistence.
  ENDMETHOD.

  METHOD run_without_package.
    TRY.
        mo_cut->yif_cqa_aunit_service_api~read_by_package( iv_devclass = '' ).
      CATCH ycx_cqa_aunit_service_api INTO DATA(lx_error).
    ENDTRY.
    cl_abap_unit_assert=>assert_bound( act = lx_error msg = 'A missing package should produce an exception' ).
  ENDMETHOD.

  METHOD run_with_invalid_date.
    TRY.
        mo_cut->yif_cqa_aunit_service_api~read_by_package( iv_devclass = 'YCQA' iv_exec_date = '20000230' ).
      CATCH ycx_cqa_aunit_service_api INTO DATA(lx_error).
    ENDTRY.
    cl_abap_unit_assert=>assert_bound( act = lx_error msg = 'An invalid date should produce an exception' ).
  ENDMETHOD.

  METHOD run_with_test_double.
    DATA(lt_result) = mo_cut->yif_cqa_aunit_service_api~read_by_package( iv_exec_date = sy-datum iv_devclass = 'ZFI_EK' ).
    cl_abap_unit_assert=>assert_equals( exp = get_expected_result( sy-datum ) act = lt_result msg = 'The result does not match the expectation' ).
  ENDMETHOD.

  METHOD get_expected_result.
    rt_result = VALUE #( ( objtype = 'CLAS' objname = 'ZCL_TEST_DOUBLE_1' devclass = 'ZSUBPACKAGE_1' exec_date = iv_exec_date
                            tests_total         = 2   tests_failed       = 0
                            cov_branch_total    = 40  cov_branch_exec    = 36
                            cov_proc_total      = 4   cov_proc_exec      = 4
                            cov_statement_total = 66  cov_statement_exec = 65
                          )
                          ( objtype = 'CLAS' objname = 'ZCL_TEST_DOUBLE_2' devclass = 'ZSUBPACKAGE_2' exec_date = ( iv_exec_date - 1 )
                            tests_total         = 2   tests_failed       = 0
                            cov_branch_total    = 40  cov_branch_exec    = 36
                            cov_proc_total      = 4   cov_proc_exec      = 4
                            cov_statement_total = 66  cov_statement_exec = 65
                          )
                          ( objtype = 'FUGR' objname = 'ZTEST_DOUBLE_PROGRAM' devclass = 'ZSUBPACKAGE_2' exec_date = iv_exec_date
                            tests_total         = 8   tests_failed       = 1
                            cov_branch_total    = 56  cov_branch_exec    = 1
                            cov_proc_total      = 13  cov_proc_exec      = 1
                            cov_statement_total = 169 cov_statement_exec = 2
                          )
                             ).
  ENDMETHOD.

ENDCLASS.
