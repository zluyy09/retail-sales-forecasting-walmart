WITH base AS (
  SELECT
    c.customer_id,
    MAX(o.order_date) AS last_order_date,
    COUNT(CASE WHEN o.status='completed' THEN 1 END) AS frequency,
    SUM(CASE WHEN o.status='completed' THEN o.revenue ELSE 0 END) AS monetary
  FROM customers c
  LEFT JOIN orders o ON o.customer_id = c.customer_id
  GROUP BY 1
), ref AS ( SELECT MAX(order_date) AS ref_date FROM orders ),
rfm AS (
  SELECT b.customer_id,
         datediff('day', b.last_order_date, (SELECT ref_date FROM ref)) AS recency_days,
         COALESCE(b.frequency,0) AS frequency,
         COALESCE(b.monetary,0.0) AS monetary
  FROM base b
)
SELECT customer_id, recency_days, frequency, monetary,
       CASE WHEN recency_days <= 30 THEN 5 WHEN recency_days <= 60 THEN 4 WHEN recency_days <= 120 THEN 3 WHEN recency_days <= 240 THEN 2 ELSE 1 END AS r_score,
       CASE WHEN frequency >= 12 THEN 5 WHEN frequency >= 8 THEN 4 WHEN frequency >= 4 THEN 3 WHEN frequency >= 2 THEN 2 ELSE 1 END AS f_score,
       CASE WHEN monetary >= 1000 THEN 5 WHEN monetary >= 500 THEN 4 WHEN monetary >= 200 THEN 3 WHEN monetary >= 50 THEN 2 ELSE 1 END AS m_score
FROM rfm;
