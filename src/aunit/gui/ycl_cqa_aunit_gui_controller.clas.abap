CLASS ycl_cqa_aunit_gui_controller DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS mc_alv_container TYPE oio_cntnr_name VALUE 'CONTAINER_ALV' ##NO_TEXT.
    CONSTANTS:
      BEGIN OF mc_ucomm,
        back   TYPE syucomm VALUE 'BACK',
        exit   TYPE syucomm VALUE 'EXIT',
        cancel TYPE syucomm VALUE 'CANCEL',
      END OF mc_ucomm .

    METHODS constructor
      IMPORTING
        !iv_devclass  TYPE devclass
        !iv_exec_date TYPE ycqa_aunit_exec_date
        !io_service   TYPE REF TO yif_cqa_aunit_service_api OPTIONAL.
    "! <p class="shorttext synchronized" lang="de">Read Unit Test Data</p>
    METHODS read_data
      RAISING
        ycx_cqa_aunit_service_api .
    "! <p class="shorttext synchronized" lang="de">Administration of User Command</p>
    "! @parameter iv_ucomm | User Command
    METHODS process_ucomm
      IMPORTING
        !iv_ucomm TYPE syucomm .
    "! <p class="shorttext synchronized" lang="de"> Initialization of ALV Grid</p>
    METHODS init_alv .
    "! <p class="shorttext synchronized" lang="de">Display list</p>
    METHODS display_alv .

    "! <p class="shorttext synchronized" lang="de">Calculate the percentage of two values.</p>
    "! @parameter iv_value_1 |
    "! @parameter iv_value_2 |
    "! @parameter rv_percentage |
    METHODS compute_percentage
      IMPORTING
        !iv_value_1          TYPE i
        !iv_value_2          TYPE i
      RETURNING
        VALUE(rv_percentage) TYPE ycqa_proc_pr .

    METHODS get_header_fields
      RETURNING
        VALUE(rs_header_fields) TYPE ycqa_aunit_dynpro_fields_s .
  PRIVATE SECTION.

    DATA mo_service TYPE REF TO yif_cqa_aunit_service_api .
    DATA mo_alv TYPE REF TO cl_salv_table .
    DATA mo_alv_container TYPE REF TO cl_gui_custom_container .
    DATA mt_aunit_data TYPE ycqa_aunit_ext_resp_t .
    DATA mv_devclass TYPE devclass .
    DATA mv_exec_date TYPE ycqa_aunit_exec_date .
    DATA mv_ucomm TYPE syucomm .

    METHODS enable_toolbar .
    METHODS create_alv_gui_container .
    METHODS create_salv_instance .
    METHODS setup_layout .
ENDCLASS.



CLASS ycl_cqa_aunit_gui_controller IMPLEMENTATION.


  METHOD compute_percentage.

    CHECK iv_value_1 >= 0.

    rv_percentage = (  iv_value_2 * 100 ) / iv_value_1.

  ENDMETHOD.


  METHOD constructor.
    mv_devclass  = iv_devclass.
    mv_exec_date = iv_exec_date.
    mo_service = COND #( WHEN io_service IS BOUND THEN io_service ELSE NEW ycl_cqa_aunit_service_api( ) ).
  ENDMETHOD.


  METHOD create_alv_gui_container.

    IF mo_alv_container IS NOT BOUND.
      mo_alv_container = NEW cl_gui_custom_container( container_name = mc_alv_container ).
    ENDIF.

  ENDMETHOD.


  METHOD create_salv_instance.

    CHECK mo_alv IS NOT BOUND.

    TRY.
        cl_salv_table=>factory(
        EXPORTING
        container_name = CONV #( mc_alv_container )
        r_container = mo_alv_container
          IMPORTING
           r_salv_table = mo_alv
          CHANGING
            t_table     = mt_aunit_data
        ).

      CATCH cx_salv_msg INTO DATA(lx_salv_msg).
        MESSAGE lx_salv_msg TYPE 'E'.
    ENDTRY.

  ENDMETHOD.


  METHOD display_alv.

    me->enable_toolbar( ).

    me->setup_layout( ).

    mo_alv->display( ).

  ENDMETHOD.


  METHOD enable_toolbar.
    DATA: lo_alv_toolbar TYPE REF TO cl_salv_functions_list.

    lo_alv_toolbar = mo_alv->get_functions( ).

    lo_alv_toolbar->set_all( ).
  ENDMETHOD.


  METHOD get_header_fields.

    DATA: lv_tests_total         TYPE  ycqa_aunit_tests_total,
          lv_tests_failed        TYPE  ycqa_aunit_tests_failed,
          lv_cov_branch_total    TYPE  ycqa_cov_branch_total,
          lv_cov_branch_exec     TYPE  ycqa_cov_branch_exec,
          lv_cov_proc_total      TYPE  ycqa_cov_proc_total,
          lv_cov_proc_exec       TYPE  ycqa_cov_proc_exec,
          lv_cov_statement_total TYPE  ycqa_cov_statement_total,
          lv_cov_statement_exec  TYPE  ycqa_cov_statement_exec.

    rs_header_fields-devclass = mv_devclass.
    rs_header_fields-exec_date = mv_exec_date.

    LOOP AT mt_aunit_data ASSIGNING FIELD-SYMBOL(<aunit_data>).
      lv_tests_total           = lv_tests_total         + <aunit_data>-tests_total.
      lv_tests_failed          = lv_tests_failed        + <aunit_data>-tests_failed.
      lv_cov_branch_total      = lv_cov_branch_total    + <aunit_data>-cov_branch_total.
      lv_cov_branch_exec       = lv_cov_branch_exec     + <aunit_data>-cov_branch_exec.
      lv_cov_proc_total        = lv_cov_proc_total      + <aunit_data>-cov_proc_total.
      lv_cov_proc_exec         = lv_cov_proc_exec       + <aunit_data>-cov_proc_exec.
      lv_cov_statement_total   = lv_cov_statement_total + <aunit_data>-cov_statement_total.
      lv_cov_statement_exec    = lv_cov_statement_exec  + <aunit_data>-cov_statement_exec.
    ENDLOOP.

    rs_header_fields-tests_failed_pr = compute_percentage( iv_value_1 = lv_tests_total iv_value_2 = lv_tests_failed ).
    rs_header_fields-cov_branch_pr = compute_percentage( iv_value_1 = lv_cov_branch_total iv_value_2 = lv_cov_branch_exec ).
    rs_header_fields-cov_proc_pr = compute_percentage( iv_value_1 = lv_cov_proc_total iv_value_2 = lv_cov_proc_exec ).
    rs_header_fields-cov_statem_pr = compute_percentage( iv_value_1 = lv_cov_statement_total iv_value_2 = lv_cov_statement_exec ).
  ENDMETHOD.


  METHOD init_alv.

    create_alv_gui_container( ).

    create_salv_instance( ).

  ENDMETHOD.


  METHOD process_ucomm.
    mv_ucomm = iv_ucomm.

    CASE mv_ucomm.
      WHEN mc_ucomm-back OR mc_ucomm-exit OR mc_ucomm-cancel.
        LEAVE TO SCREEN 0.

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.


  METHOD read_data.

    mt_aunit_data = mo_service->read_by_package(
                      iv_devclass  = mv_devclass
                      iv_exec_date = mv_exec_date
                    ).

  ENDMETHOD.


  METHOD setup_layout.

    DATA(lo_layout) = mo_alv->get_layout( ).
    DATA ls_layout_key TYPE salv_s_layout_key.

    ls_layout_key-report = sy-repid.

    lo_layout->set_key( ls_layout_key ).

    lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
    lo_layout->set_default( abap_true ).

  ENDMETHOD.
ENDCLASS.
