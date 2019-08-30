INTERFACE yif_cqa_aunit_worker
  PUBLIC .

  METHODS run_aunit_kpi
    IMPORTING
      it_object_list            TYPE yif_cqa_aunit_package_query=>tt_development_elements
      io_aunit_cvrg_preparation TYPE REF TO ycl_cqa_aunit_cvrg_preparation
      io_aunit_rslt_preparation TYPE REF TO ycl_cqa_aunit_rslt_preparation
    RAISING
      cx_scv_execution_error.


ENDINTERFACE.
