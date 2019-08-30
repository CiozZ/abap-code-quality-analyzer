REPORT ycqa_aunit_runner.
DATA:
     gv_devclass TYPE devclass.

SELECT-OPTIONS s_pack FOR gv_devclass OBLIGATORY.

START-OF-SELECTION.
  DATA(go_runner_handler) = NEW ycl_cqa_aunit_runner_handler( ).
  go_runner_handler->run( s_pack[] ).
