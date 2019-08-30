CLASS lcl_cqa_aunit_res_db_double DEFINITION.

  PUBLIC SECTION.
    INTERFACES: yif_cqa_aunit_res_db.
ENDCLASS.

CLASS lcl_cqa_aunit_res_db_double IMPLEMENTATION.

  METHOD yif_cqa_aunit_res_db~insert_db.
    ##TODO " Test der korrekten Daten ggf. via Memory Schreiben und in Testmethode auslesen um zu prüfen, ob Daten korrekt erzeugt wurden
    DATA(lv_time) = sy-uzeit.
    rv_execution_okay_code = COND #( WHEN it_db_result = VALUE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data( ( execution_date = sy-datum
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
                                                                                                        cov_statement_exec = '96.00' ) )
                                                        THEN abap_true
                                                        ELSE abap_false ).
  ENDMETHOD.

  METHOD yif_cqa_aunit_res_db~read_from_db.
    " iS NOT USED HERE
  ENDMETHOD.

ENDCLASS.
