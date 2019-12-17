@AbapCatalog.sqlViewName: 'ycqa_cds_pkglist'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Package List'
define view ycqa_cds_package_list 

as select from ycqa_aunit_res {
 
    key ycqa_aunit_res.execution_date,
    key ycqa_aunit_res.execution_time,
    key ycqa_aunit_res.package_name,
    key ycqa_aunit_res.object_name,
    key ycqa_aunit_res.object_type
 
}
