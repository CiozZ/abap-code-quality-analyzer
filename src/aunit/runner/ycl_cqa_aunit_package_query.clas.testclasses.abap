CLASS ltc_package_query DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS mc_package_zfi_ek_gf TYPE devclass VALUE 'ZFI_EK_GF' ##NO_TEXT.
    CONSTANTS mc_package_zfi_ek TYPE devclass VALUE 'ZFI_EK' ##NO_TEXT.
    CONSTANTS mc_package_ycqa TYPE devclass VALUE 'YCQA' ##NO_TEXT.

    DATA mo_sut TYPE REF TO ycl_cqa_aunit_package_query.

    METHODS setup.

    METHODS get_all_elements_for_selection FOR TESTING.
    METHODS get_all_elements_4_single_pack FOR TESTING.
    METHODS get_hierachy_three FOR TESTING.

ENDCLASS.


CLASS ltc_package_query IMPLEMENTATION.

  METHOD setup.
    mo_sut = NEW ycl_cqa_aunit_package_query( ).
  ENDMETHOD.

  METHOD get_all_elements_for_selection.
    cl_abap_unit_assert=>assert_equals( msg = 'Die Anzahl der Elemente sollte 184 sein!'
                                        exp = 184
                                        act = lines( mo_sut->yif_cqa_aunit_package_query~get_all_elements_for_package( VALUE #( ( sign = 'I' option = 'EQ' low = mc_package_zfi_ek ) ) ) )
                                      ).
  ENDMETHOD.

  METHOD get_all_elements_4_single_pack.
    cl_abap_unit_assert=>assert_equals( msg = 'Die Anzahl der Elemente sollte 15 sein!'
                                        exp = 15
                                        act = lines( mo_sut->yif_cqa_aunit_package_query~get_all_elements_for_package( VALUE #( ( sign = 'I' option = 'EQ' low = mc_package_zfi_ek_gf ) ) ) )
                                      ).
  ENDMETHOD.

  METHOD get_hierachy_three.
    cl_abap_unit_assert=>assert_equals( msg = 'Die Anzahl der Elemente sollte 17 sein!'
                                        exp = 17
                                        act = lines( mo_sut->yif_cqa_aunit_package_query~get_all_elements_for_package( VALUE #( ( sign = 'I' option = 'EQ' low = mc_package_ycqa ) ) ) )
                                      ).
  ENDMETHOD.

ENDCLASS.
