@AbapCatalog.sqlViewName: 'ycqa_cds_topperc'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prozentberechnung zu View YCQA_CDS_TOP_OBJECTS'
define view ycqa_cds_top_objects_percent as select from ycqa_cds_top_objects {
    object_name,
    case 
    when sum_cov_statement_total > 0 then
      division( sum_cov_statement_executed, sum_cov_statement_total, 2 ) * 100
//      cast( sum_cov_statement_executed as abap.fltp ) / cast( sum_cov_statement_total as abap.fltp )
     else 0
     
    end as percentage
    
}

