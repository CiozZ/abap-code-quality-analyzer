INTERFACE yif_cqa_aunit_res_db
  PUBLIC .

  METHODS
    "! Reading UNIT-Test_Data from Database
    "! @parameter iv_execute_date | Execution Date of UNIT-Tests
    "! @parameter iv_package_name | Name of requested Package
    "! @parameter rt_aunit_db_data | List of UNIT-Test-Data
    read_from_db
      IMPORTING iv_execution_date       TYPE datum
                iv_package_name         TYPE devclass
      RETURNING VALUE(rt_aunit_db_data) TYPE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data.

  METHODS
    "! Insert UNIT-Test-Data in Database
    "! @parameter it_db_result | List of UNIT-Test-Data
    "! @parameter rv_result | Execution-Feedback Okay = |X| / Not Okay = | |
    insert_db
      IMPORTING it_db_result                  TYPE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data
      RETURNING VALUE(rv_execution_okay_code) TYPE abap_bool.

ENDINTERFACE.
