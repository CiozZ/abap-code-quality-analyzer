CLASS ycl_cqa_aunit_worker DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES yif_cqa_aunit_worker .

    METHODS get_unit_tests_for_objects
      IMPORTING
        it_object_list            TYPE yif_cqa_aunit_package_query=>tt_development_elements
      RETURNING
        VALUE(rt_unit_test_table) TYPE cl_aucv_task=>ty_object_directory_elements .
  PRIVATE SECTION.

    CONSTANTS mc_obj_type_function_group TYPE string VALUE 'FUGR' ##NO_TEXT.
    CONSTANTS mc_obj_type_dev_class TYPE string VALUE 'DEVC' ##NO_TEXT.
    CONSTANTS mc_obj_type_program TYPE string VALUE 'PROG' ##NO_TEXT.
    CONSTANTS mc_obj_type_class TYPE tadir-object VALUE 'CLAS' ##NO_TEXT.
    CONSTANTS mc_pgmid_r3tr TYPE string VALUE 'R3TR' ##NO_TEXT.
    CONSTANTS mc_equal_sign TYPE string VALUE `=` ##NO_TEXT.





    METHODS get_aunit_results
      IMPORTING
                it_object_list            TYPE yif_cqa_aunit_package_query=>tt_development_elements
                io_aunit_cvrg_preparation TYPE REF TO ycl_cqa_aunit_cvrg_preparation
                io_aunit_rslt_preparation TYPE REF TO ycl_cqa_aunit_rslt_preparation
      RAISING   cx_scv_execution_error.



    METHODS run_unit_tests
      IMPORTING
        it_unit_tests_table       TYPE cl_aucv_task=>ty_object_directory_elements
        io_aunit_rslt_preparation TYPE REF TO ycl_cqa_aunit_rslt_preparation
      RETURNING
        VALUE(ro_task)            TYPE REF TO cl_aucv_task
      RAISING
        cx_dynamic_check.

    METHODS determine_test_results
      IMPORTING
                it_object_list            TYPE yif_cqa_aunit_package_query=>tt_development_elements
                io_aunit_cvrg_preparation TYPE REF TO ycl_cqa_aunit_cvrg_preparation
                io_test_run_task          TYPE REF TO cl_aucv_task
      RAISING   cx_scv_execution_error.

    METHODS prepare_and_run_tests
      IMPORTING
        it_object_list            TYPE yif_cqa_aunit_package_query=>tt_development_elements
        io_aunit_rslt_preparation TYPE REF TO ycl_cqa_aunit_rslt_preparation
      RETURNING
        VALUE(ro_result)          TYPE REF TO cl_aucv_task.

ENDCLASS.



CLASS ycl_cqa_aunit_worker IMPLEMENTATION.


  METHOD determine_test_results.

    io_aunit_cvrg_preparation->set_coverage_measurement(
        it_object_list          = it_object_list
        io_coverage_measurement = io_test_run_task->get_coverage_measurement( ) ).

  ENDMETHOD.


  METHOD get_aunit_results.

    DATA(lo_task) = prepare_and_run_tests(
        it_object_list = it_object_list
        io_aunit_rslt_preparation      = io_aunit_rslt_preparation ).

    determine_test_results(
        it_object_list   = it_object_list
        io_aunit_cvrg_preparation   = io_aunit_cvrg_preparation
        io_test_run_task = lo_task ).
  ENDMETHOD.


  METHOD get_unit_tests_for_objects.

    LOOP AT it_object_list INTO DATA(ls_data).

      rt_unit_test_table = VALUE #( BASE rt_unit_test_table (
          object = ls_data-element->dev_elem_type
          obj_name = ls_data-element->dev_elem_key ) ) .

    ENDLOOP.

  ENDMETHOD.


  METHOD prepare_and_run_tests.

    ro_result = run_unit_tests(
        it_unit_tests_table = get_unit_tests_for_objects( it_object_list )
        io_aunit_rslt_preparation           = io_aunit_rslt_preparation ).

  ENDMETHOD.


  METHOD run_unit_tests.

    ro_task  = cl_aucv_task=>create(
        i_listener = io_aunit_rslt_preparation
        i_measure_coverage = abap_true
      ).

    ro_task->add_associated_unit_tests( it_unit_tests_table ).
    ro_task->run( if_aunit_task=>c_run_mode-external ).

  ENDMETHOD.


  METHOD yif_cqa_aunit_worker~run_aunit_kpi.

    get_aunit_results(
      EXPORTING
        it_object_list = it_object_list
        io_aunit_cvrg_preparation = io_aunit_cvrg_preparation
        io_aunit_rslt_preparation      = io_aunit_rslt_preparation
    ).

  ENDMETHOD.
ENDCLASS.
