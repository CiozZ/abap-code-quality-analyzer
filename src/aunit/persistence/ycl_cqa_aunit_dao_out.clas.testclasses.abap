CLASS ltcl_aunit_dao_out DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.


  PRIVATE SECTION.
    DATA:
      mo_cut TYPE REF TO yif_cqa_aunit_dao_out.

    METHODS:
      setup,
      read_data_in_database FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_aunit_dao_out IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW ycl_cqa_aunit_dao_out( io_aunit_res_db = NEW lcl_cqa_aunit_res_db_double( ) ).
  ENDMETHOD.

  METHOD read_data_in_database.
    GET TIME STAMP FIELD DATA(lv_timestamp).
    cl_abap_unit_assert=>assert_equals( exp = VALUE yif_cqa_aunit_dao_out=>tt_aunit_result( ( execution_date = sy-datum
                                                                                                package_name = 'ZFI_EK'
                                                                                                object_name = 'ZCL_EK_PIH'
                                                                                                object_type = 'CLASS'
                                                                                                tests_total = 10
                                                                                                tests_failed = 2
                                                                                                cov_branch_total = '101.00'
                                                                                                cov_branch_exec = '100.00'
                                                                                                cov_proc_total = '99.00'
                                                                                                cov_proc_exec = '98.00'
                                                                                                cov_statement_total = '97.00'
                                                                                                cov_statement_exec = '96.00' ) )
                                        act = mo_cut->read_unit_tests_results(
                                                iv_execution_date    = sy-datum
                                                iv_package_name = 'ZFI_EK'
                                              ) ).
  ENDMETHOD.

ENDCLASS.
