*"* use this source file for your ABAP unit test classes

CLASS ltc_controller DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA: mo_cut TYPE REF TO ycl_cqa_aunit_gui_controller.

    METHODS:
      setup,
      compute_percentage FOR TESTING.
ENDCLASS.


CLASS ltc_controller IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( iv_devclass = 'ZFI_EK' iv_exec_date = sy-datum io_service = NEW ycl_cqa_aunit_service_tdouble( ) ).
  ENDMETHOD.

  METHOD compute_percentage.

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = mo_cut->compute_percentage(
                                 iv_value_1 = 55
                                 iv_value_2 = 7
                               )
        exp                  = '12.73'
    ).

  ENDMETHOD.

ENDCLASS.
