CLASS ycl_cqa_aunit_dao_out DEFINITION
 PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: yif_cqa_aunit_dao_out.

    METHODS constructor
      IMPORTING
        io_aunit_res_db TYPE REF TO yif_cqa_aunit_res_db OPTIONAL.

  PRIVATE SECTION.
    DATA:
      mo_aunit_res_db TYPE REF TO yif_cqa_aunit_res_db.

    METHODS:
      mapping_from_db
        IMPORTING it_aunit_db_data     TYPE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data
        RETURNING VALUE(rt_aunit_data) TYPE yif_cqa_aunit_dao_out=>tt_aunit_result,
      read_from_db
        IMPORTING iv_execution_date       TYPE datum
                  iv_package_name         TYPE devclass
        RETURNING VALUE(rt_aunit_db_data) TYPE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data,
      create_selection_executiondate
        IMPORTING
          iv_execute_date                TYPE datum
        RETURNING
          VALUE(rt_execution_date_range) TYPE yif_cqa_aunit_res_db_dao=>tt_execution_date_range.

ENDCLASS.

CLASS ycl_cqa_aunit_dao_out IMPLEMENTATION.

  METHOD yif_cqa_aunit_dao_out~read_unit_tests_results.
    ##TODO " Check if package name is filled and exists (Exception-Handling definition)
    rt_aunit_data = mapping_from_db( read_from_db( iv_execution_date = iv_execution_date
                                                  iv_package_name = iv_package_name ) ).
  ENDMETHOD.

  METHOD mapping_from_db.
    rt_aunit_data = CORRESPONDING #( it_aunit_db_data ).
  ENDMETHOD.

  METHOD read_from_db.
    rt_aunit_db_data = mo_aunit_res_db->read_from_db( iv_execution_date = iv_execution_date
                                                      iv_package_name   = iv_package_name ).
  ENDMETHOD.

  METHOD create_selection_executiondate.
    rt_execution_date_range  = VALUE yif_cqa_aunit_res_db_dao=>tt_execution_date_range( ( sign = 'I' option = 'EQ' low = iv_execute_date ) ).
  ENDMETHOD.

  METHOD constructor.
    mo_aunit_res_db = COND #( WHEN io_aunit_res_db IS BOUND THEN io_aunit_res_db ELSE NEW ycl_cqa_aunit_res_db( NEW ycl_cqa_aunit_res_db_dao( ) ) ).
  ENDMETHOD.

ENDCLASS.

