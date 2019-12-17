@AbapCatalog.sqlViewName: 'ycqa_cds_topobjs'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS for top objects'
define view ycqa_cds_top_objects as select from ycqa_aunit_res {
    
    object_name,
    sum(cov_statement_exec) as sum_cov_statement_executed,
    sum(cov_statement_total) as sum_cov_statement_total
    
}

group by object_name
