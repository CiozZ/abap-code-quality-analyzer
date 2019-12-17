@AbapCatalog.sqlViewName: 'ycqa_cds_statsum'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Statement Summary'
define view YCQA_CDS_STATEMENT_SUMMARY as select from ycqa_aunit_res {

    sum(cov_statement_exec) as sum_cov_statement_executed,
    sum(cov_statement_total) as sum_cov_statement_total
}