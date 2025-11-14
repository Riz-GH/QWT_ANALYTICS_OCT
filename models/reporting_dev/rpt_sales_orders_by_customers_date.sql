{{ config(materialized = 'view', schema = 'reporting_dev')}}
 
with customer_orders as
(
    select
    customerid,
    min(orderdate) as first_order_date,
    max(orderdate) as recent_order_date,
    count(distinct orderid) as total_orders,
    sum(quantity) as total_quantity,
    sum(linesalesamount) as total_sales
 
    from
 
    {{ ref('fct_orders') }}
 
    group by 1
 
),
 
customers as
(
    select customerid,
    companyname,
    contactname
    from
    {{ref('dim_customers')}}
),
 
customers_orders_sales as
(
    select
    c.companyname,
    c.contactname,
    co.first_order_date,
    co.recent_order_date,
    co.total_orders,
    co.total_quantity,
    co.total_sales
 
    from
 
    customer_orders as co inner join
    customers as c on co.customerid = c.customerid
),
 
order_dates as
(
    select date_day,
    day_of_week_name
    from
    {{ref('dim_date')}}
)
 
select companyname,
    contactname,
    first_order_date,
    od.day_of_week_name as first_order_day,
    recent_order_date,
    total_orders,
    total_quantity,
    total_sales
 
    from customers_orders_sales as cos
    inner join order_dates as od
    on cos.first_order_date = od.date_day