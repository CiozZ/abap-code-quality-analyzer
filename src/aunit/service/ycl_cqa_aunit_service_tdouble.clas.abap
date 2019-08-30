"!<p class="shorttext synchronized" lang="de">Test Double zum externen Interface</p>
CLASS ycl_cqa_aunit_service_tdouble DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES yif_cqa_aunit_service_api.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS YCL_CQA_AUNIT_SERVICE_TDOUBLE IMPLEMENTATION.


  METHOD yif_cqa_aunit_service_api~read_by_package.

    rt_aunit_data = VALUE #(
    ( objtype = |CLAS| objname = |ZCL_EK_ALVSCR_TDOUBLE| devclass = |ZFI_EK_GUI| exec_date = sy-datum tests_total = 8 tests_failed = 0
    cov_branch_total = 197 cov_branch_exec = 70
    cov_proc_total = 31 cov_proc_exec = 18
    cov_statement_total = 360 cov_statement_exec = 156 )

    ( objtype = |CLAS| objname = |ZCL_EK_SERVICE_TDOUBLE| devclass = |ZFI_EK_GUI| exec_date = sy-datum tests_total = 15 tests_failed = 4
    cov_branch_total = 20 cov_branch_exec = 10
    cov_proc_total = 10 cov_proc_exec = 7
    cov_statement_total = 25 cov_statement_exec = 17 )

    ( objtype = |CLAS| objname = |ZCL_EK_ALINK_TDOUBLE| devclass = |ZFI_EK_ALINK| exec_date = sy-datum tests_total = 1 tests_failed = 0
    cov_branch_total = 30 cov_branch_exec = 4
    cov_proc_total = 5 cov_proc_exec = 2
    cov_statement_total = 46 cov_statement_exec = 6 )

    ( objtype = |FUGR| objname = |SAPLZFI_EK_GUI_TDOUBLE| devclass = |ZFI_EK_GUI| exec_date = sy-datum tests_total = 3 tests_failed = 0
    cov_branch_total = 42 cov_branch_exec = 4
    cov_proc_total = 14 cov_proc_exec = 2
    cov_statement_total = 90 cov_statement_exec = 8 )
    ).

  ENDMETHOD.
ENDCLASS.
