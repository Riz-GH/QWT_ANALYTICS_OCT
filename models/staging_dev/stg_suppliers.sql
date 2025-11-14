{{config(materialized = 'table', schema = env_var('DBT_STGSCHEMA_NAME', 'STAGING_DEV')) }}

select 
get(xmlget(suppliersinfo, 'SupplierID'),'$') as SupplierID,
get(xmlget(suppliersinfo, 'CompanyName'),'$')::VARCHAR as CompanyName,
get(xmlget(suppliersinfo, 'ContactName'),'$')::VARCHAR as ContactName,
get(xmlget(suppliersinfo, 'Address'),'$')::VARCHAR as Address,
get(xmlget(suppliersinfo, 'City'),'$')::VARCHAR as City,
get(xmlget(suppliersinfo, 'Country'),'$')::VARCHAR as Country,
get(xmlget(suppliersinfo, 'Phone'),'$')::VARCHAR as Phone,
get(xmlget(suppliersinfo, 'Fax'),'$')::VARCHAR as Fax
from 
{{source("qwt_raw", "raw_suppliers")}}