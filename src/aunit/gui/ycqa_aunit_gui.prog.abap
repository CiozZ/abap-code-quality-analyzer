*&---------------------------------------------------------------------*
*& Report ycqa_gui
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ycqa_aunit_gui.

PARAMETERS: p_devcl  TYPE devclass OBLIGATORY DEFAULT 'ZFI_EK',
            p_excdat TYPE ycqa_aunit_exec_date DEFAULT sy-datum,
            p_testmd AS CHECKBOX DEFAULT abap_false.


START-OF-SELECTION.

  CALL FUNCTION 'YCQA_START_AUNIT_DASHBOARD'
    EXPORTING
      iv_devclass  = p_devcl               " Package
      iv_exec_date = p_excdat              " Execution Date
      iv_testmode  = p_testmd.             " Test Mode
