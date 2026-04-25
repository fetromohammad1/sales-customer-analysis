E-Commerce Customer & Operations Analysis using SQL (BigQuery)

1. Total Revenue per Customer
Top customer menyumbang revenue paling tinggi dalam dataset ini.
SELECT
  customer_name,
  SUM(total_sales) AS total_revenue
FROM `data-analyst-project-479415.project_dummy.ecommerce_sales_customer_analytics`
GROUP BY customer_name
ORDER BY total_revenue DESC;

Insight:

Terdapat beberapa pelanggan yang memberikan kontribusi revenue jauh lebih tinggi dibandingkan pelanggan lainnya.
Hal ini menunjukkan adanya high-value customers yang memiliki dampak signifikan terhadap pendapatan perusahaan.
Strategi bisnis sebaiknya fokus pada retensi dan loyalitas pelanggan ini.

2. Customer Ranking berdasarkan Revenue
Ranking menunjukkan bahwa sebagian kecil customer memberikan kontribusi revenue yang jauh lebih besar dibanding yang lain.
SELECT
  customer_name,
  SUM(total_sales) AS total_revenue,
  RANK() OVER (ORDER BY SUM(total_sales) DESC) AS customer_rank
FROM `data-analyst-project-479415.project_dummy.ecommerce_sales_customer_analytics`
GROUP BY customer_name;

Insight:

Customer dapat diperingkat berdasarkan kontribusi revenue.
Ranking ini membantu perusahaan dalam menentukan prioritas pelanggan untuk program marketing dan retensi.

3. Customer Segmentation
Sebagian customer masuk kategori VIP dengan kontribusi transaksi lebih tinggi, sementara mayoritas berada di kategori Regular dan Low Value.
SELECT
  customer_segment,
  COUNT(*) AS total_customer
FROM (
  SELECT
    customer_name,
    CASE
      WHEN SUM(total_sales) >= 4000 THEN 'VIP'
      WHEN SUM(total_sales) >= 3000 THEN 'Regular'
      ELSE 'Low Value'
    END AS customer_segment
  FROM `data-analyst-project-479415.project_dummy.ecommerce_sales_customer_analytics`
  GROUP BY customer_name
)
GROUP BY customer_segment
ORDER BY total_customer DESC;
Insight:

Pelanggan dapat dikelompokkan ke dalam beberapa segmen berdasarkan nilai transaksi.
Segmentasi ini membantu perusahaan dalam menyusun strategi yang lebih tepat sasaran:
VIP: loyalty program & exclusive offers
Regular: upselling strategy
Low Value: engagement & reactivation campaign

4. Revenue Contribution (Pareto Analysis)
Hanya beberapa customer yang menyumbang porsi besar dari total revenue, sementara sisanya berkontribusi dalam jumlah yang lebih kecil.
SELECT
  customer_name,
  SUM(total_sales) AS revenue,
  ROUND(
    SUM(total_sales) / SUM(SUM(total_sales)) OVER() * 100, 2
  ) AS revenue_contribution_pct
FROM `data-analyst-project-479415.project_dummy.ecommerce_sales_customer_analytics`
GROUP BY customer_name
ORDER BY revenue_contribution_pct DESC;

Insight:

Sebagian kecil pelanggan berkontribusi terhadap sebagian besar revenue.
Hal ini mengindikasikan adanya pola Pareto Principle (80/20 rule) dalam perilaku pelanggan.
Fokus strategi bisnis sebaiknya diarahkan pada mempertahankan top contributor customers.

5.RFM Analysis (Advanced Customer Segmentation)
Ada customer dengan nilai pembelian tinggi, namun sebagian di antaranya sudah lama tidak melakukan transaksi, sehingga berpotensi perlu strategi re-engagement.
WITH rfm AS (
  SELECT
    customer_id,
    MAX(order_date) AS last_order_date,
    COUNT(order_id) AS frequency,
    SUM(total_sales) AS monetary
  FROM `data-analyst-project-479415.project_dummy.ecommerce_sales_customer_analytics`
  GROUP BY customer_id
)

SELECT
  customer_id,
  DATE_DIFF(CURRENT_DATE(), last_order_date, DAY) AS recency,
  frequency,
  monetary
FROM rfm
ORDER BY monetary DESC
LIMIT 10;

Insight:

RFM digunakan untuk mengukur nilai pelanggan berdasarkan perilaku transaksi.
Customer dengan monetary tinggi dan recency rendah adalah target utama retensi.
Ini membantu strategi CRM dan customer loyalty program.

6.Delivery Status Analysis
Status pengiriman tidak merata, dan ada beberapa kategori status yang bisa menjadi perhatian karena berpotensi mempengaruhi pengalaman pelanggan.
SELECT
  delivery_status,
  COUNT(order_id) AS total_orders,
  ROUND(
    COUNT(order_id) * 100 / SUM(COUNT(order_id)) OVER(),
    2
  ) AS percentage_orders
FROM `data-analyst-project-479415.project_dummy.ecommerce_sales_customer_analytics`
GROUP BY delivery_status
ORDER BY total_orders DESC;
💡 Insight:

Menunjukkan distribusi status pengiriman.
Jika terdapat “pending” atau “cancelled” tinggi, itu sinyal masalah operasional.
Data ini bisa digunakan untuk meningkatkan efisiensi logistik dan customer satisfaction.


