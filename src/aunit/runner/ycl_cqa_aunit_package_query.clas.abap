CLASS ycl_cqa_aunit_package_query DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES yif_cqa_aunit_package_query.

    "! Constructor of class
    METHODS constructor.
    METHODS collect_all_packages
      IMPORTING
        it_packages            TYPE scompaksel
      RETURNING
        VALUE(rt_all_packages) TYPE scompaklis.

  PRIVATE SECTION.

    METHODS select_packages
      IMPORTING it_package_selection TYPE scompaksel
      RETURNING VALUE(rt_packages)   TYPE scompaklis.

    METHODS get_all_elements_from_package
      IMPORTING io_package         TYPE REF TO if_package
      RETURNING VALUE(rt_elements) TYPE pakdevelemtab.

    METHODS read_all_sub_packages
      IMPORTING
        io_package         TYPE REF TO if_package
      RETURNING
        VALUE(rt_packages) TYPE scompaklis.


    METHODS collect_all_dev_elements
      IMPORTING
        it_packages                    TYPE scompaklis
      RETURNING
        VALUE(rt_development_elements) TYPE yif_cqa_aunit_package_query=>tt_development_elements.

    METHODS filter_dev_elements_for_aunit
      IMPORTING
        it_all_elements          TYPE yif_cqa_aunit_package_query=>tt_development_elements
      RETURNING
        VALUE(rt_aunit_elements) TYPE yif_cqa_aunit_package_query=>tt_development_elements.

ENDCLASS.

CLASS ycl_cqa_aunit_package_query IMPLEMENTATION.

  METHOD yif_cqa_aunit_package_query~get_all_elements_for_package.

    DATA(lt_packages) = collect_all_packages( it_packages ).
    DATA(lt_all_elements) = collect_all_dev_elements( lt_packages ).
    rt_development_elements = filter_dev_elements_for_aunit( lt_all_elements ).

  ENDMETHOD.

  METHOD collect_all_dev_elements.
    rt_development_elements = VALUE #( FOR lo_package IN it_packages
                                       FOR lo_element IN me->get_all_elements_from_package( lo_package )
                                        ( package = lo_package element = lo_element )
                                      ).
  ENDMETHOD.

  METHOD collect_all_packages.
    rt_all_packages = select_packages( it_packages ).
    rt_all_packages = VALUE #( BASE rt_all_packages
                               FOR lo_package IN rt_all_packages
                               FOR lo_sub_package IN read_all_sub_packages( lo_package )
                                ( lo_sub_package )
                             ).
  ENDMETHOD.

  METHOD filter_dev_elements_for_aunit.
    rt_aunit_elements = VALUE #( FOR lo_element IN it_all_elements
                                  WHERE ( element->dev_elem_type = 'CLAS' OR
                                          element->dev_elem_type = 'PROG' OR
                                          element->dev_elem_type = 'FUGR' )
                                  ( lo_element )
                               ).
  ENDMETHOD.

  METHOD select_packages.
    cl_package_factory=>bulk_load_selected_packages(
      EXPORTING
        i_package_selection = it_package_selection
        i_force_reload      = abap_false
      IMPORTING
        e_packages          = rt_packages
      EXCEPTIONS
        no_data_selected    = 1
        unexpected_error    = 2
        intern_err          = 3
        no_access           = 4
        OTHERS              = 5
    ).
  ENDMETHOD.

  METHOD get_all_elements_from_package.
    io_package->get_elements(
      EXPORTING
        i_check_existence = abap_true
      IMPORTING
        e_elements        = rt_elements
    ).
  ENDMETHOD.

  METHOD constructor.

    cl_package_factory=>initialize(
     EXCEPTIONS
       system_not_configured = 1
       system_layer_not_read = 2
       no_access             = 3
       OTHERS                = 4
   ).

  ENDMETHOD.

  METHOD read_all_sub_packages.
    io_package->get_sub_packages(
      IMPORTING
        e_sub_packages   = rt_packages
      EXCEPTIONS
        object_invalid   = 1
        leaf_package     = 2
        unexpected_error = 3
        OTHERS           = 4
    ).
    CHECK sy-subrc = 2.
    LOOP AT rt_packages INTO DATA(lo_package).
      APPEND LINES OF read_all_sub_packages( lo_package ) TO rt_packages.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
