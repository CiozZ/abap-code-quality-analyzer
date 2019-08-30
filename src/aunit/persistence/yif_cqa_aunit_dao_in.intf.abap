INTERFACE yif_cqa_aunit_dao_in

  PUBLIC .
  TYPES: BEGIN OF ts_aunit_result,
           execution_date      TYPE ycqa_aunit_exec_date,
           execution_time      TYPE ycqa_aunit_exec_time,
           package_name        TYPE devclass,
           object_name         TYPE sobj_name,
           object_type         TYPE ycqa_aunit_objtype,
           tests_total         TYPE ycqa_aunit_tests_total,
           tests_failed        TYPE ycqa_aunit_tests_failed,
           cov_branch_total    TYPE ycqa_cov_branch_total,
           cov_branch_exec     TYPE ycqa_cov_branch_exec,
           cov_proc_total      TYPE ycqa_cov_proc_total,
           cov_proc_exec       TYPE ycqa_cov_proc_exec,
           cov_statement_total TYPE ycqa_cov_statement_total,
           cov_statement_exec  TYPE ycqa_cov_statement_exec,
         END OF ts_aunit_result.
  TYPES: tt_aunit_result TYPE STANDARD TABLE OF ts_aunit_result WITH DEFAULT KEY.
  METHODS
    save_data_in_database
      IMPORTING
                it_aunit_result        TYPE tt_aunit_result
      RETURNING VALUE(rv_db_insert_ok) TYPE abap_bool.
ENDINTERFACE.
