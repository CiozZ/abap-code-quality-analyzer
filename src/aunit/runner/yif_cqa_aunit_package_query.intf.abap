INTERFACE yif_cqa_aunit_package_query
  PUBLIC .

  TYPES: BEGIN OF ty_development_element,
           package TYPE REF TO if_package,
           element TYPE REF TO if_pak_dev_element,
         END OF ty_development_element.
  TYPES tt_development_elements TYPE STANDARD TABLE OF ty_development_element WITH NON-UNIQUE DEFAULT KEY.

  "! <p class="shorttext synchronized">Delivers all unit test relevant development objects</p>
  "! @parameter it_packages | <p class="shorttext synchronized">Requested development objects</p>
  "! @parameter rt_development_elements | <p class="shorttext synchronized" lang="en">All relevant objects</p>
  METHODS get_all_elements_for_package
    IMPORTING
      it_packages                    TYPE scompaksel
    RETURNING
      VALUE(rt_development_elements) TYPE tt_development_elements.

ENDINTERFACE.
