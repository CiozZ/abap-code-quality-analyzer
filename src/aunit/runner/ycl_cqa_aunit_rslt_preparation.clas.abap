CLASS ycl_cqa_aunit_rslt_preparation DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    ##TODO "Unit Test
    TYPES:
      BEGIN OF ty_s_alerts,
        program TYPE progname,
        class   TYPE stringval,
        method  TYPE stringval,
        title   TYPE stringval,
      END OF ty_s_alerts.

    TYPES:
      tt_alerts TYPE STANDARD TABLE OF ty_s_alerts WITH NON-UNIQUE DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_methods,
        program TYPE progname,
        class   TYPE stringval,
        method  TYPE stringval,
        summary TYPE if_aunit_info_step_end=>ty_s_alert_summary,
      END OF ty_s_methods.

    TYPES tt_methods        TYPE STANDARD TABLE OF ty_s_methods WITH NON-UNIQUE DEFAULT KEY.

    TYPES tt_alerts_summary TYPE STANDARD TABLE OF if_aunit_info_step_end=>ty_s_alert_summary WITH NON-UNIQUE DEFAULT KEY.

    INTERFACES if_aunit_listener.

    METHODS constructor.

    METHODS get_alerts
      RETURNING
        VALUE(rt_alerts) TYPE tt_alerts.

    METHODS get_status
      RETURNING
        VALUE(rt_status) TYPE tt_methods.

  PRIVATE SECTION.
    DATA mt_alerts   TYPE tt_alerts.
    DATA ms_alerts   TYPE ty_s_alerts.
    DATA mo_text_api TYPE REF TO if_aunit_text_description.
    DATA mt_methods  TYPE tt_methods.

ENDCLASS.

CLASS ycl_cqa_aunit_rslt_preparation IMPLEMENTATION.

  METHOD if_aunit_listener~assert_failure.

    ms_alerts-title = mo_text_api->get_string( failure->get_header_description( ) ).
    APPEND ms_alerts TO mt_alerts.

  ENDMETHOD.

  METHOD if_aunit_listener~class_end.

    CLEAR ms_alerts-class.

  ENDMETHOD.

  METHOD if_aunit_listener~class_start.

    ms_alerts-class = info->name.

  ENDMETHOD.

  METHOD if_aunit_listener~cx_failure.

    ms_alerts-title = mo_text_api->get_string( failure->get_header_description( ) ).
    APPEND ms_alerts TO mt_alerts.

  ENDMETHOD.

  METHOD if_aunit_listener~execution_event.

  ENDMETHOD.

  METHOD if_aunit_listener~method_end.

    APPEND VALUE #( class = ms_alerts-class
                            method = ms_alerts-method
                            program = ms_alerts-program
                            summary = info->get_alert_summary( )
                  ) TO mt_methods.
    CLEAR ms_alerts-method.

  ENDMETHOD.

  METHOD if_aunit_listener~method_start.

    ms_alerts-method = info->name.

  ENDMETHOD.

  METHOD if_aunit_listener~program_end.

    CLEAR ms_alerts-program.

  ENDMETHOD.

  METHOD if_aunit_listener~program_start.

    ms_alerts-program = info->name.

  ENDMETHOD.

  METHOD if_aunit_listener~rt_failure.

    ms_alerts-title = mo_text_api->get_string( failure->get_header_description( ) ).
    APPEND ms_alerts TO mt_alerts.

  ENDMETHOD.

  METHOD if_aunit_listener~task_end.

  ENDMETHOD.

  METHOD if_aunit_listener~task_start.

  ENDMETHOD.

  METHOD if_aunit_listener~warning.

    ms_alerts-title = mo_text_api->get_string( warning->get_header_description( ) ).
    APPEND ms_alerts TO mt_alerts.

  ENDMETHOD.

  METHOD get_alerts.
    rt_alerts = mt_alerts.
  ENDMETHOD.

  METHOD get_status.
    rt_status = mt_methods.
  ENDMETHOD.

  METHOD constructor.

    mo_text_api = NEW cl_aunit_factory( )->get_text_converter( ).

  ENDMETHOD.
ENDCLASS.
