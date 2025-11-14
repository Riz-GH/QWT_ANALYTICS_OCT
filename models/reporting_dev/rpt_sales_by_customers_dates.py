import snowflake.snowpark.functions as F
import pandas as pd 
import holidays

def is_holiday(orderdate):

    us_holidays = holidays.US()

    is_holiday = (orderdate in us_holidays)

    return is_holiday

def avg_order(x,y):

    return x/y

def model(dbt, session):

    #dbt.config(materialized = 'table', schema = 'reporting_dev', packages = ['holidays'])# --to be removed while using in yml file

    df_orders = dbt.ref('fct_orders')

    df_customers = dbt.ref('dim_customers')

    df_grouped_orders = df_orders.groupBy('customerid').agg(
        
        F.min('orderdate').alias('First_Order_Date'),
        F.max('orderdate').alias('Recent_Order_Date'),
        F.countDistinct('orderid').alias('Total_Orders'),
        F.sum('Quantity').alias('Total_Quantity'),
        F.sum('LineSalesAmount').alias('Total_Sales'),
        F.avg('Margin').alias('Avg_margin')
        
    )
    
    #df_customers = dbt.ref('dim_customers') --here also we can use this#

    df_customers_orders = df_grouped_orders.join(df_customers,df_grouped_orders.customerid == df_customers.customerid, 'left'
    )

    df_customers_orders = df_customers_orders.select(
        F.col('CompanyName'),
        F.col('ContactName'),
        F.col('First_Order_Date'),
        F.col('Recent_Order_Date'),
        F.col('Total_Orders'),
        F.col('Total_Quantity'),
        F.col('Total_Sales'),
        F.col('Avg_margin')
    )

    df_customers_orders = df_customers_orders.withColumn('Avg_order_value', avg_order(df_customers_orders['Total_Sales'],df_customers_orders['Total_Orders']))

    df_customers_orders = df_customers_orders.filter(F.col('First_Order_Date').isNotNull())
    
    df_customers_orders_holidays = df_customers_orders.to_pandas()

    df_customers_orders_holidays['is_first_order_date_holiday'] = df_customers_orders_holidays['FIRST_ORDER_DATE'].apply(is_holiday)

    return df_customers_orders_holidays
