CLASS lcl_aunit_red_db_dao_double DEFINITION.
  PUBLIC SECTION.
    INTERFACES: yif_cqa_aunit_res_db_dao.

ENDCLASS.

CLASS lcl_aunit_red_db_dao_double IMPLEMENTATION.

  METHOD yif_cqa_aunit_res_db_dao~select_data_by_package_date.
    DATA(lt_aunit_db_data) = VALUE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data(
    ( execution_date = '20190830' execution_time = '230000' package_name = 'YCQA_AUNIT_PERSISTENCE' object_name = 'CLASSA' object_type = 'CLASS')
    ( execution_date = '20190830' execution_time = '220000' package_name = 'YCQA_AUNIT_PERSISTENCE' object_name = 'CLASSA' object_type = 'CLASS')
    ( execution_date = '20190829' execution_time = '220000' package_name = 'YCQA_AUNIT_PERSISTENCE' object_name = 'CLASSA' object_type = 'CLASS')
    ( execution_date = '20190830' execution_time = '230000' package_name = 'YCQA_AUNIT_GUI' object_name = 'CLASSB' object_type = 'CLASS')
    ( execution_date = '20190830' execution_time = '220000' package_name = 'YCQA_AUNIT_GUI' object_name = 'CLASSB' object_type = 'CLASS')
    ( execution_date = '20190829' execution_time = '220000' package_name = 'YCQA_AUNIT_GUI' object_name = 'CLASSB' object_type = 'CLASS')
    ( execution_date = '20190830' execution_time = '230000' package_name = 'ZCSS' object_name = 'CLASSC' object_type = 'CLASS')
    ).
    LOOP AT lt_aunit_db_data INTO DATA(ls_data) WHERE package_name   IN it_package_name
                                                AND   execution_date IN it_execution_date.
      APPEND ls_data TO rt_aunit_db_data.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
