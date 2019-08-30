*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_persistence_test_double DEFINITION.

  PUBLIC SECTION.
    INTERFACES yif_cqa_aunit_dao_out.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_persistence_test_double IMPLEMENTATION.

  METHOD yif_cqa_aunit_dao_out~read_unit_tests_results.

    rt_aunit_data = VALUE #( ( object_type = 'CLAS' object_name = 'ZCL_TEST_DOUBLE_1' package_name = 'ZSUBPACKAGE_1' execution_date = iv_execution_date
                               tests_total         = 2   tests_failed       = 0
                               cov_branch_total    = 40  cov_branch_exec    = 36
                               cov_proc_total      = 4   cov_proc_exec      = 4
                               cov_statement_total = 66  cov_statement_exec = 65
                             )
                             ( object_type = 'CLAS' object_name = 'ZCL_TEST_DOUBLE_2' package_name = 'ZSUBPACKAGE_2' execution_date = ( iv_execution_date - 1 )
                               tests_total         = 2   tests_failed       = 0
                               cov_branch_total    = 40  cov_branch_exec    = 36
                               cov_proc_total      = 4   cov_proc_exec      = 4
                               cov_statement_total = 66  cov_statement_exec = 65
                             )
                             ( object_type = 'FUGR' object_name = 'ZTEST_DOUBLE_PROGRAM' package_name = 'ZSUBPACKAGE_2' execution_date = iv_execution_date
                               tests_total         = 8   tests_failed       = 1
                               cov_branch_total    = 56  cov_branch_exec    = 1
                               cov_proc_total      = 13  cov_proc_exec      = 1
                               cov_statement_total = 169 cov_statement_exec = 2
                             )
                                ).
  ENDMETHOD.

ENDCLASS.
