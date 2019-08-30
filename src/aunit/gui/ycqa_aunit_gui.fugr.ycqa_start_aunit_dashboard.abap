FUNCTION YCQA_START_AUNIT_DASHBOARD.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IV_DEVCLASS) TYPE  DEVCLASS
*"     REFERENCE(IV_EXEC_DATE) TYPE  YCQA_AUNIT_EXEC_DATE
*"     REFERENCE(IV_TESTMODE) TYPE  FLAG
*"----------------------------------------------------------------------
  go_controller = NEW ycl_cqa_aunit_gui_controller( iv_devclass  = iv_devclass
                                                    iv_exec_date = iv_exec_date
                                                    io_service   = COND #( WHEN iv_testmode = abap_true THEN NEW ycl_cqa_aunit_service_tdouble( ) ) ).

  CALL SCREEN 2000.

ENDFUNCTION.
