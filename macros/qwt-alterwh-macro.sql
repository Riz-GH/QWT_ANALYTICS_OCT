{% macro grant_alterwh(warehouse) %}
 
{% set vsetwarehouse %}

ALTER WAREHOUSE {{warehouse}} SET warehouse_size=Medium;

{% endset %}

{% do run_query(vsetwarehouse) %}

{% do log("warehouse is assigned", info=true ) %}

{% endmacro %}