# “Customer Revenue Insights: Top Spenders & Average Order Value”
SELECT
  customer_id,
  customer_name,
  SUM(total_sales) AS total_revenue,
  COUNT(order_id),
  ROUND(SUM(total_sales)/COUNT(order_id), 2) AS avg_order_value
FROM `data-analyst-project-479415.project_dummyy.ecommerce_sales_customer_analytics`
GROUP BY customer_id, customer_name
ORDER BY total_revenue DESC
LIMIT 10;


# Average Unit Price
SELECT
  Product as Total_Product,
  SUM(Total_Sales) as Total_Revenue,
  SUM(Quantity) as Unit_Sold,
  ROUND(SUM(Total_Sales)/SUM(Quantity), 2) as avg_unit_price
FROM `data-analyst-project-479415.project_dummyy.ecommerce_sales_customer_analytics`
GROUP BY Product
ORDER BY total_revenue DESC
limit 10;

# “Regional Sales Insights: Total Revenue, Orders & Average Revenue per Order”
SELECT
  Region as Regions,
  SUM(Total_Sales) as Total_Profit,
  COUNT(Order_ID) as Total_Order
FROM `data-analyst-project-479415.project_dummyy.ecommerce_sales_customer_analytics`
GROUP BY Region
ORDER BY Total_Profit;

# “Monthly Sales Insights: Total Revenue & Total Orders”
SELECT
 FORMAT_DATE("%Y-%m", order_date) as Month,
 SUM(Total_Sales) as Montly_Revenue,
 COUNT(order_id) as total_oder
FROM `data-analyst-project-479415.project_dummyy.ecommerce_sales_customer_analytics`
GROUP BY Month
ORDER BY Month;

# “Customer Value Analysis: Recency, Frequency & Monetary (RFM)”
WITH rfm as (
  SELECT
  customer_id,
  MAX(order_date) as last_order_date,
  COUNT(order_id) as frequency,
  SUM(total_sales) as monetary
FROM `data-analyst-project-479415.project_dummyy.ecommerce_sales_customer_analytics`
GROUP BY customer_id
)

SELECT
  customer_id,
  DATE_DIFF(CURRENT_DATE(), last_order_date, DAY) recency,
  frequency,
  monetary
FROM rfm
ORDER BY monetary;

# “Delivery Status Distribution: Total Orders & Percentage per Status”
SELECT
  delivery_status,
  COUNT(order_id) as Total_Orders,
  ROUND(COUNT(order_id) * 100 / SUM(COUNT(order_id)) OVER(), 2) as Per_Order
FROM `data-analyst-project-479415.project_dummyy.ecommerce_sales_customer_analytics`
GROUP BY delivery_status
ORDER BY Total_Orders;



