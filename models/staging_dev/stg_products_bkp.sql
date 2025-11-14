{{ config(materialized='table', transient = false,
pre_hook = "use warehouse compute_wh;", 
post_hook = "create or replace table QWT_DEV.STAGING_DEV.STG_PRODUCTS_TEST CLONE QWT_DEV.STAGING_DEV.STG_PRODUCTS_BKP;") }}
select 
*
from 
{{ source("qwt_raw", "raw_products") }}