{# {{ config(materialized = 'table', schema = 'transforming_dev') }} #}
{{ config(materialized = 'table', schema = env_var('DBT_STGSCHEMA_NAME', 'TRANSFORMING_DEV')) }}

select
    p.productid,
    p.productname,
    c.categoryname,
    s.companyname as suppliercompany,
    s.contactname as suppliercontact,
    s.city as suppliercity,
    s.country as suppliercountry,
    p.quantityperunit,
    p.unitcost,
    p.unitprice,
    p.unitsinstock,
    p.unitsonorder,
    iff(
        p.unitsinstock > unitsonorder, 'ProductAvailable', 'ProductNotAvailable'
    ) as productavailability

from {{ ref("stg_products") }} as p
inner join {{ ref("stg_suppliers") }} as s on (p.supplierid = s.supplierid)
inner join {{ ref("lkp_categories") }} as c on (p.categoryid = c.categoryid)
