CLASS ycl_cqa_aunit_data_provider DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING io_aunit_rslt_preparation TYPE REF TO ycl_cqa_aunit_rslt_preparation
                io_aunit_cvrg_preparation TYPE REF TO ycl_cqa_aunit_cvrg_preparation
                it_development_elements   TYPE yif_cqa_aunit_package_query=>tt_development_elements.

    METHODS collect_all_results.

    METHODS save_results_in_db.

    METHODS get_all_test_results
      RETURNING
        VALUE(rt_test_results) TYPE yif_cqa_aunit_dao_in=>tt_aunit_result.

  PRIVATE SECTION.

    DATA mo_aunit_rslt_preparation TYPE REF TO ycl_cqa_aunit_rslt_preparation.
    DATA mo_aunit_cvrg_preparation TYPE REF TO ycl_cqa_aunit_cvrg_preparation.
    DATA mt_development_elements TYPE yif_cqa_aunit_package_query=>tt_development_elements.
    DATA mt_results TYPE yif_cqa_aunit_dao_in=>tt_aunit_result.


    METHODS get_dev_element
      IMPORTING iv_program            TYPE progname
      RETURNING VALUE(ro_dev_element) TYPE REF TO if_pak_dev_element.
    METHODS get_dev_package
      IMPORTING
        iv_program        TYPE csequence
      RETURNING
        VALUE(ro_package) TYPE REF TO if_package.
    METHODS get_tadir_name_from_progname
      IMPORTING
        iv_program     TYPE progname
      RETURNING
        VALUE(rv_name) TYPE tadir-obj_name.

ENDCLASS.


CLASS ycl_cqa_aunit_data_provider IMPLEMENTATION.

  METHOD constructor.
    mt_development_elements = it_development_elements.
    mo_aunit_rslt_preparation = io_aunit_rslt_preparation.
    mo_aunit_cvrg_preparation = io_aunit_cvrg_preparation.

    mo_aunit_cvrg_preparation->set_object_list( mt_development_elements ).
    TRY.
        mo_aunit_cvrg_preparation->if_aucv_cvrg_rslt_provider~build_coverage_result( ).
      CATCH cx_scv_execution_error cx_scv_call_error.

    ENDTRY.
  ENDMETHOD.


  METHOD get_all_test_results.
    DATA:
      lv_total_failed TYPE i,
      lv_total_tests  TYPE i.


    DATA(lt_methods) = mo_aunit_rslt_preparation->get_status( ).
    LOOP AT lt_methods ASSIGNING FIELD-SYMBOL(<program>)
        GROUP BY <program>-program.

      DATA(lo_element) = get_dev_element( <program>-program ).
      DATA(lo_package) = get_dev_package( <program>-program ).

      lo_package->get_package_name(
        IMPORTING
          e_package_name = DATA(lv_package_name)
        EXCEPTIONS
          object_invalid = 1
          intern_err     = 2
          OTHERS         = 3
      ).

      CLEAR: lv_total_failed, lv_total_tests.
      LOOP AT GROUP <program> ASSIGNING FIELD-SYMBOL(<result>).
        lv_total_failed = SWITCH i( <result>-summary-is_okay
                                              WHEN abap_false THEN 1 + lv_total_failed
                                            ).
        lv_total_tests = lv_total_tests + 1.
      ENDLOOP.
      DATA(lo_result_object) = mo_aunit_cvrg_preparation->get_result_object( <program>-program ).
      DATA(ls_dao_in) = VALUE  yif_cqa_aunit_dao_in=>ts_aunit_result(
                                  execution_date = sy-datum
                                  execution_time = sy-uzeit
                                  package_name = lv_package_name
                                  object_name = lo_element->dev_elem_key
                                  object_type = lo_element->dev_elem_type
                                  tests_failed = lv_total_failed
                                  tests_total  = lv_total_tests
                                  cov_branch_exec = lo_result_object->get_coverage( ce_scv_coverage_type=>branch )->get_executed( )
                                  cov_branch_total = lo_result_object->get_coverage( ce_scv_coverage_type=>branch )->get_total( )
                                  cov_proc_exec = lo_result_object->get_coverage( ce_scv_coverage_type=>procedure )->get_executed( )
                                  cov_proc_total = lo_result_object->get_coverage( ce_scv_coverage_type=>procedure )->get_total( )
                                  cov_statement_exec = lo_result_object->get_coverage( ce_scv_coverage_type=>statement )->get_executed( )
                                  cov_statement_total = lo_result_object->get_coverage( ce_scv_coverage_type=>statement )->get_total( )
                                ).
      APPEND ls_dao_in TO rt_test_results.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_dev_element.
    LOOP AT mt_development_elements INTO DATA(ls_dev_element)
        WHERE element->dev_elem_key = get_tadir_name_from_progname( iv_program ).
      ro_dev_element = ls_dev_element-element.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_dev_package.
    LOOP AT mt_development_elements INTO DATA(ls_dev_element)
        WHERE element->dev_elem_key = get_tadir_name_from_progname( iv_program ).
      ro_package = ls_dev_element-package.
    ENDLOOP.
  ENDMETHOD.

  METHOD collect_all_results.
    mt_results = get_all_test_results( ).
  ENDMETHOD.

  METHOD save_results_in_db.
    DATA(lo_dao_in) = CAST yif_cqa_aunit_dao_in( NEW ycl_cqa_aunit_dao_in( ) ).
    lo_dao_in->save_data_in_database( mt_results ).
  ENDMETHOD.

  METHOD get_tadir_name_from_progname.
    cl_aunit_prog_info=>progname_to_tadir(
      EXPORTING
        progname = iv_program
      IMPORTING
        obj_name =      rv_name
    ).
  ENDMETHOD.

ENDCLASS.
