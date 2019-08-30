INTERFACE lif_cqa_aunit_res_db.

  METHODS
    insert_db
      IMPORTING it_db_result     TYPE ycl_cqa_aunit_dao_in=>yif_cqa_aunit_dao_in~tt_aunit_result
      RETURNING VALUE(rv_result) TYPE abap_bool.

ENDINTERFACE.
