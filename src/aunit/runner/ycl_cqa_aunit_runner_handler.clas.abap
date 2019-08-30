CLASS ycl_cqa_aunit_runner_handler DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA mo_aunit_data_provider TYPE REF TO ycl_cqa_aunit_data_provider READ-ONLY.

    METHODS run
      IMPORTING
        it_packages TYPE scompaksel
      RAISING
        cx_scv_execution_error.
ENDCLASS.



CLASS ycl_cqa_aunit_runner_handler IMPLEMENTATION.
  METHOD run.

    DATA(lt_object_list) = NEW ycl_cqa_aunit_package_query( )->yif_cqa_aunit_package_query~get_all_elements_for_package( it_packages ).
    DATA(lo_aunit_rslt_preparation) = NEW ycl_cqa_aunit_rslt_preparation( ).
    DATA(lo_aunit_cvrg_preparation) = NEW ycl_cqa_aunit_cvrg_preparation( ).

    DATA(lo_cqa_aunit_worker) = CAST yif_cqa_aunit_worker( NEW ycl_cqa_aunit_worker( ) ).

    TRY.
        lo_cqa_aunit_worker->run_aunit_kpi(
            it_object_list = lt_object_list
            io_aunit_cvrg_preparation = lo_aunit_cvrg_preparation
            io_aunit_rslt_preparation     = lo_aunit_rslt_preparation
          ).
    ENDTRY.

    mo_aunit_data_provider = NEW ycl_cqa_aunit_data_provider(
                                       io_aunit_rslt_preparation = lo_aunit_rslt_preparation
                                       io_aunit_cvrg_preparation = lo_aunit_cvrg_preparation
                                       it_development_elements  = lt_object_list
                                    ).

    mo_aunit_data_provider->collect_all_results( ).

    mo_aunit_data_provider->save_results_in_db( ).

  ENDMETHOD.

ENDCLASS.
