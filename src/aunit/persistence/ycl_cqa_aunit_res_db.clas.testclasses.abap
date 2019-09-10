CLASS ltc_aunit_res_dab DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
      mo_cut TYPE REF TO yif_cqa_aunit_res_db.
    METHODS:
      setup,
      read_from_db FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_aunit_res_dab IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW ycl_cqa_aunit_res_db( NEW lcl_aunit_red_db_dao_double( ) ).
  ENDMETHOD.

  METHOD read_from_db.
    cl_abap_unit_assert=>assert_equals( exp = VALUE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data(
    ( execution_date = '20190830' execution_time = '230000' package_name = 'YCQA_AUNIT_GUI' object_name = 'CLASSB' object_type = 'CLASS' )
    ( execution_date = '20190830' execution_time = '230000' package_name = 'YCQA_AUNIT_PERSISTENCE' object_name = 'CLASSA' object_type = 'CLASS' )
    )
                                        act = mo_cut->read_from_db( iv_execution_date = '20190830' iv_package_name = 'YCQA_AUNIT' ) ).
  ENDMETHOD.


ENDCLASS.
