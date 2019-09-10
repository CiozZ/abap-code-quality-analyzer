CLASS ycl_cqa_aunit_cvrg_preparation DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_aucv_cvrg_rslt_provider.
    TYPES ty_result_list          TYPE TABLE OF REF TO if_scv_result WITH DEFAULT KEY.
    METHODS set_coverage_measurement
      IMPORTING
        io_coverage_measurement TYPE REF TO if_scv_measurement
        it_object_list          TYPE yif_cqa_aunit_package_query=>tt_development_elements.
    METHODS set_object_list
      IMPORTING
        it_object_list TYPE yif_cqa_aunit_package_query=>tt_development_elements.
    METHODS get_result_list RETURNING VALUE(rt_result_list) TYPE ty_result_list.
    METHODS get_result_object
      IMPORTING
        iv_object_name   TYPE progname
      RETURNING
        VALUE(ro_object) TYPE REF TO if_scv_result.

  PRIVATE SECTION.

    DATA mo_coverage_measurement TYPE REF TO if_scv_measurement.
    DATA mo_coverage_result      TYPE REF TO if_scv_result.
    DATA mt_object_list          TYPE yif_cqa_aunit_package_query=>tt_development_elements.
    DATA mt_result_list          TYPE ty_result_list.

ENDCLASS.

CLASS ycl_cqa_aunit_cvrg_preparation IMPLEMENTATION.

  METHOD if_aucv_cvrg_rslt_provider~build_coverage_result.

    IF ( mo_coverage_result IS BOUND ).
      result = mo_coverage_result.
      RETURN.
    ENDIF.

    LOOP AT mt_object_list ASSIGNING FIELD-SYMBOL(<object>).
      DATA(lv_progname) = cl_aunit_prog_info=>tadir_to_progname( obj_type = <object>-element->dev_elem_type
                                                                 obj_name = CONV #( <object>-element->dev_elem_key ) ).

      TRY.
          DATA(lo_result) = mo_coverage_measurement->build_program_result( lv_progname ).
          mt_result_list = VALUE #( BASE mt_result_list ( lo_result ) ).
        CATCH  cx_scv_execution_error
               cx_scv_call_error.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.

  METHOD set_coverage_measurement.

    mo_coverage_measurement = io_coverage_measurement.

  ENDMETHOD.

  METHOD set_object_list.

    me->mt_object_list = it_object_list.

  ENDMETHOD.

  METHOD get_result_list.

    rt_result_list = me->mt_result_list.

  ENDMETHOD.

  METHOD get_result_object.

    LOOP AT mt_result_list INTO ro_object.
      IF ro_object->get_name( ) = iv_object_name.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
