-- DuckDB-compatible clv_simple.sql
WITH hist AS (
  SELECT
    o.customer_id,
    COUNT(*) FILTER (WHERE o.status = 'completed') AS n_orders,
    SUM(CASE WHEN o.status = 'completed' THEN o.revenue ELSE 0 END) AS revenue
  FROM orders o
  GROUP BY 1
),
avg_order AS (
  SELECT
    customer_id,
    CASE WHEN n_orders = 0 THEN 0 ELSE revenue * 1.0 / n_orders END AS aov
  FROM hist
),
ref AS ( SELECT MAX(order_date) AS ref_date FROM orders ),
freq AS (
  SELECT
    o.customer_id,
    COUNT(*) FILTER (
      WHERE o.status = 'completed'
        AND o.order_date >= (SELECT ref_date FROM ref) - INTERVAL '365' DAY
    ) AS orders_12m
  FROM orders o
  GROUP BY 1
)
SELECT
  f.customer_id,
  a.aov,
  f.orders_12m,
  a.aov * (f.orders_12m + 0.5) AS clv_proxy
FROM freq f
LEFT JOIN avg_order a USING (customer_id);

