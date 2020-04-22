@AbapCatalog.sqlViewName: 'ycqa_cds_sumtab'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Summary als Tabelle'
define view ycqa_cds_summary_table as select from YCQA_CDS_STATEMENT_SUMMARY {
    
    'Executed' as description,
    sum_cov_statement_executed as value
    
}

union select from YCQA_CDS_STATEMENT_SUMMARY {

    'Not_Executed' as description,
    sum_cov_statement_total - sum_cov_statement_executed as value
    
}
