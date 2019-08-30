CLASS ycl_cqa_aunit_res_db_dao DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: yif_cqa_aunit_res_db_dao.

ENDCLASS.

CLASS ycl_cqa_aunit_res_db_dao IMPLEMENTATION.

  METHOD yif_cqa_aunit_res_db_dao~select_data_by_package_date.
    ##TODO " Selection Logic includes that objects that changed the package still are selected. Maybe this should be changed
    ##TODO " Index  anschauen / Buffer anschauen / Timestamp refactor
    SELECT * FROM ycqa_aunit_res INTO TABLE rt_aunit_db_data
        WHERE execution_date IN it_execution_date
        AND package_name     IN it_package_name.
  ENDMETHOD.

ENDCLASS.
