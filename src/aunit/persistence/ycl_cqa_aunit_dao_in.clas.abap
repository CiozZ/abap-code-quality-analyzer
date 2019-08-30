CLASS ycl_cqa_aunit_dao_in DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: yif_cqa_aunit_dao_in.

    METHODS constructor
      IMPORTING
        io_aunit_res_db TYPE REF TO yif_cqa_aunit_res_db OPTIONAL.

  PRIVATE SECTION.
    DATA:
      mo_aunit_res_db TYPE REF TO yif_cqa_aunit_res_db.

    METHODS:
      mapping_to_db
        IMPORTING it_aunit_result     TYPE yif_cqa_aunit_dao_in=>tt_aunit_result
        RETURNING VALUE(rt_db_result) TYPE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data,
      save_to_db
        IMPORTING it_db_result     TYPE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data
        RETURNING VALUE(rv_result) TYPE abap_bool.

ENDCLASS.

CLASS ycl_cqa_aunit_dao_in IMPLEMENTATION.

  METHOD constructor.
    mo_aunit_res_db = COND #( WHEN io_aunit_res_db IS BOUND THEN io_aunit_res_db ELSE NEW ycl_cqa_aunit_res_db( ) ).
  ENDMETHOD.

  METHOD yif_cqa_aunit_dao_in~save_data_in_database.
    rv_db_insert_ok = save_to_db(
                        mapping_to_db( it_aunit_result ) ).
  ENDMETHOD.

  METHOD mapping_to_db.
    rt_db_result = CORRESPONDING #( it_aunit_result ).
  ENDMETHOD.

  METHOD save_to_db.
    rv_result = mo_aunit_res_db->insert_db( it_db_result ).
  ENDMETHOD.


ENDCLASS.
