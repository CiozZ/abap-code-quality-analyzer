CLASS ycl_cqa_aunit_res_db DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      yif_cqa_aunit_res_db.

    METHODS
      constructor
        IMPORTING io_db_dao TYPE REF TO yif_cqa_aunit_res_db_dao OPTIONAL.
  PRIVATE SECTION.
    DATA:
      mo_res_db_dao TYPE REF TO yif_cqa_aunit_res_db_dao.

    METHODS:
      sort_data
        IMPORTING
                  it_aunit_db_data        TYPE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data
        RETURNING VALUE(rt_aunit_db_data) TYPE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data,
      remove_duplicates
        IMPORTING
                  it_aunit_db_data        TYPE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data
        RETURNING VALUE(rt_aunit_db_data) TYPE yif_cqa_aunit_res_db_dao=>tt_aunit_db_data,
      get_pack_hierarchy_range
        IMPORTING
          iv_package_name             TYPE devclass
        RETURNING
          VALUE(rt_package_hierarchy) TYPE scompaksel,
      get_package_range
        IMPORTING
                  iv_package_name         TYPE devclass
        RETURNING VALUE(rt_package_range) TYPE scompaksel,
      create_package_range
        IMPORTING
          it_packages             TYPE scompaklis
        RETURNING
          VALUE(rt_package_range) TYPE scompaksel,
      get_executiondate_range
        IMPORTING
          iv_execute_date                TYPE datum
        RETURNING
          VALUE(rt_execution_date_range) TYPE yif_cqa_aunit_res_db_dao=>tt_execution_date_range..
ENDCLASS.

CLASS ycl_cqa_aunit_res_db IMPLEMENTATION.

  METHOD yif_cqa_aunit_res_db~read_from_db.
    rt_aunit_db_data = remove_duplicates(
                         sort_data(
                           mo_res_db_dao->select_data_by_package_date(
                             it_package_name   = get_pack_hierarchy_range( iv_package_name )
                             it_execution_date = get_executiondate_range( iv_execution_date ) ) ) ).
  ENDMETHOD.

  METHOD get_pack_hierarchy_range.
    DATA(lt_packages) = NEW ycl_cqa_aunit_package_query( )->collect_all_packages( get_package_range( iv_package_name ) ).
    rt_package_hierarchy = create_package_range( lt_packages ).
  ENDMETHOD.

  METHOD create_package_range.
    DATA ls_package_range TYPE scomseltyp.

    LOOP AT it_packages INTO DATA(lo_package).
      ls_package_range-sign   = 'I'.
      ls_package_range-option = 'EQ'.
      lo_package->get_package_name( IMPORTING e_package_name = ls_package_range-low ).
      APPEND ls_package_range TO rt_package_range.
    ENDLOOP.
  ENDMETHOD.

  METHOD remove_duplicates.
    rt_aunit_db_data = it_aunit_db_data.
    DELETE ADJACENT DUPLICATES FROM rt_aunit_db_data
        COMPARING package_name
        object_name
        object_type.
  ENDMETHOD.

  METHOD sort_data.
    rt_aunit_db_data = it_aunit_db_data.
    SORT rt_aunit_db_data BY
        package_name
        object_name
        object_type
        execution_date DESCENDING
        execution_time DESCENDING.
  ENDMETHOD.

  METHOD yif_cqa_aunit_res_db~insert_db.
    INSERT ycqa_aunit_res FROM TABLE it_db_result.

    IF sy-subrc = 0.
      ##TODO " Ggf. auslagern / Abstimmen mit Aufrufer
      COMMIT WORK AND WAIT.
      rv_execution_okay_code = abap_true.
    ELSE.
      ROLLBACK WORK.
      rv_execution_okay_code = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD get_package_range.
    rt_package_range = VALUE #( ( sign = 'I' option = 'EQ' low = iv_package_name ) ).
  ENDMETHOD.

  METHOD get_executiondate_range.
    rt_execution_date_range  = COND #( WHEN iv_execute_date IS NOT INITIAL THEN VALUE yif_cqa_aunit_res_db_dao=>tt_execution_date_range( ( sign = 'I' option = 'EQ' low = iv_execute_date ) ) ).
  ENDMETHOD.

  METHOD constructor.
    mo_res_db_dao = COND #( WHEN io_db_dao IS BOUND THEN io_db_dao ELSE NEW ycl_cqa_aunit_res_db_dao(  ) ).
  ENDMETHOD.

ENDCLASS.
