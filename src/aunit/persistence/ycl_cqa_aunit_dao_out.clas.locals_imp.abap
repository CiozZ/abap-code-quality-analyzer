CLASS lcl_cqa_aunit_res_db_double DEFINITION.

  PUBLIC SECTION.
    INTERFACES: yif_cqa_aunit_res_db.
ENDCLASS.

CLASS lcl_cqa_aunit_res_db_double IMPLEMENTATION.

  METHOD yif_cqa_aunit_res_db~read_from_db.
    DATA(lv_time) = sy-uzeit.
    rt_aunit_db_data = VALUE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data( ( execution_date = sy-datum
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
                                                                        cov_statement_exec = '96.00' ) ).
  ENDMETHOD.

  METHOD yif_cqa_aunit_res_db~insert_db.
    "IS NOT USED HERE
  ENDMETHOD.

ENDCLASS.
