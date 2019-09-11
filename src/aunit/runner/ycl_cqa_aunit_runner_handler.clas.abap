CLASS ycl_cqa_aunit_runner_handler DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! <p class="shorttext synchronized" lang="de">Data Provider getter.</p>
    "! @parameter ro_dataprovider |
    METHODS
      get_data_provider
        RETURNING VALUE(ro_dataprovider) TYPE REF TO ycl_cqa_aunit_data_provider.

    "! <p class="shorttext synchronized" lang="de">Runner start method</p>
    "! @parameter it_packages |
    "! @raising cx_scv_execution_error |
    METHODS run
      IMPORTING
        it_packages TYPE scompaksel
      RAISING
        cx_scv_execution_error.

  PRIVATE SECTION.
    DATA mo_aunit_data_provider TYPE REF TO ycl_cqa_aunit_data_provider.

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

  METHOD get_data_provider.
    ro_dataprovider = mo_aunit_data_provider.
  ENDMETHOD.

ENDCLASS.
