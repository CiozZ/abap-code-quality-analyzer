INTERFACE yif_cqa_aunit_res_db_dao
  PUBLIC .
  TYPES: tt_aunit_db_data        TYPE STANDARD TABLE OF ycqa_aunit_res WITH DEFAULT KEY,
         tt_execution_date_range TYPE RANGE OF ycqa_aunit_exec_date,
         ts_execution_date_range TYPE LINE OF tt_execution_date_range.

  METHODS
    select_data_by_package_date
      IMPORTING
        it_package_name         TYPE scompaksel
        it_execution_date       TYPE tt_execution_date_range
      RETURNING
        VALUE(rt_aunit_db_data) TYPE tt_aunit_db_data.
ENDINTERFACE.
