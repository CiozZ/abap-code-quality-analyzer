INTERFACE yif_cqa_aunit_service_api
  PUBLIC .

  "!<p class="shorttext synchronized" lang="de">Liefert Unit Test-Daten zu genau einem Paket</p>
  "! @parameter iv_devclass | Paketname
  "! @parameter iv_exec_date | Stichdatum der Messung
  "! @parameter rt_aunit_data |
  METHODS read_by_package
    IMPORTING iv_devclass          TYPE devclass
              iv_exec_date         TYPE ycqa_aunit_exec_date OPTIONAL
    RETURNING VALUE(rt_aunit_data) TYPE ycqa_aunit_ext_resp_t
    RAISING   ycx_cqa_aunit_service_api.

ENDINTERFACE.
