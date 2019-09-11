CLASS ycl_cqa_aunit_service_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES yif_cqa_aunit_service_api.

    METHODS constructor IMPORTING io_persistence TYPE REF TO yif_cqa_aunit_dao_out OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mo_persistence TYPE REF TO yif_cqa_aunit_dao_out.
    METHODS check_package
      IMPORTING iv_devclass TYPE devclass
      RAISING   ycx_cqa_aunit_service_api.
    METHODS check_date
      IMPORTING iv_exec_date TYPE d
      RAISING   ycx_cqa_aunit_service_api.
    METHODS map_persistence
      IMPORTING it_persistence   TYPE yif_cqa_aunit_dao_out=>tt_aunit_result
      RETURNING VALUE(rt_result) TYPE ycqa_aunit_ext_resp_t.
    METHODS read_persistence
      IMPORTING iv_devclass           TYPE devclass
                iv_exec_date          TYPE d
      RETURNING VALUE(rt_persistence) TYPE yif_cqa_aunit_dao_out=>tt_aunit_result
      RAISING   ycx_cqa_aunit_service_api.
ENDCLASS.



CLASS ycl_cqa_aunit_service_api IMPLEMENTATION.

  METHOD yif_cqa_aunit_service_api~read_by_package.

    me->check_package( iv_devclass ).
    me->check_date( iv_exec_date ).
    rt_aunit_data = me->map_persistence( read_persistence( iv_devclass = iv_devclass iv_exec_date = iv_exec_date ) ).

  ENDMETHOD.


  METHOD check_date.
    IF iv_exec_date IS NOT INITIAL.
      CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY' EXPORTING date = iv_exec_date EXCEPTIONS OTHERS = 1.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE ycx_cqa_aunit_service_api.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD check_package.
    IF iv_devclass IS INITIAL.
      RAISE EXCEPTION TYPE ycx_cqa_aunit_service_api.
    ENDIF.
  ENDMETHOD.


  METHOD constructor.
    "test double injection for persistence service
    mo_persistence = COND #( WHEN io_persistence IS BOUND THEN io_persistence ELSE NEW ycl_cqa_aunit_dao_out( ) ).
  ENDMETHOD.


  METHOD map_persistence.
    rt_result = CORRESPONDING #( it_persistence
                  MAPPING objtype   = object_type
                          objname   = object_name
                          devclass  = package_name
                          exec_date = execution_date ).
  ENDMETHOD.


  METHOD read_persistence.
    rt_persistence = mo_persistence->read_unit_tests_results( iv_execution_date = iv_exec_date iv_package_name = iv_devclass ).
  ENDMETHOD.

ENDCLASS.
