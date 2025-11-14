select
orderid,
sum(margin) as total_margin
from
{{ref('fct_orders')}}
group by orderid
having (total_margin < 0)