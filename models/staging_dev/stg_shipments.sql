{{ config(materialized='table', schema = env_var('DBT_STGSCHEMA_NAME', 'STAGING_DEV')) }}
select
 
OrderID ,
LineNo ,
ShipperID ,
CustomerID ,
ProductID ,
EmployeeID ,
To_date(split_part(ShipmentDate , ' ', 1)) as ShipmentDate,
Status
 
from
 
{{source('qwt_raw', 'raw_shipments')}}