{#{{ config(materialized = 'view', schema = 'reporting_dev') }}

select
orderid,
sum(case when lineno = 1 then linesalesamount end) as lineno1_sales,
sum(case when lineno=2  then linesalesamount end) as lineno2_sales,
sum(case when lineno=3  then linesalesamount end) as lineno3_sales,
sum(linesalesamount) as total_sales
from {{ref('fct_orders')}}
group by 1#}


{{ config(materialized = 'view', schema = 'reporting_dev')}}
 
{#{% set v_linenumbers = [1,2,3,4] %}#}

{% set v_linenumbers = get_line_numbers() %}
 
select
orderid,
 
{% for lineno in v_linenumbers %}
sum(case when lineno = {{lineno}} then linesalesamount end) as lineno{{lineno}}_sales,
{% endfor %}
 
 
sum(linesalesamount) as total_sales
 
from {{ref('fct_orders')}}
 
group by 1