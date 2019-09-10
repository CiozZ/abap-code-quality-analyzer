CLASS ltc_aunit_dao_in DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
      mo_cut TYPE REF TO yif_cqa_aunit_dao_in.

    METHODS:
      setup,
      save_data_in_database FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_aunit_dao_in IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW ycl_cqa_aunit_dao_in( NEW lcl_cqa_aunit_res_db_double( ) ).
  ENDMETHOD.

  METHOD save_data_in_database.
    DATA(lv_time) = sy-uzeit.
    cl_abap_unit_assert=>assert_equals( exp = 'X'
                                        act = mo_cut->save_data_in_database(
                                                                             VALUE yif_cqa_aunit_dao_in=>tt_aunit_result( (    execution_date = sy-datum
                                                                                                                               execution_time = lv_time
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
                                                                                                                                cov_statement_exec = '96.00' ) ) ) ).
  ENDMETHOD.

ENDCLASS.
