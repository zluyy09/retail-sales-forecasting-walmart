-- DuckDB-compatible churn_features.sql
WITH orders_clean AS (
  SELECT o.*, CASE WHEN o.status='completed' THEN 1 ELSE 0 END AS completed FROM orders o
),
ref AS (
  SELECT MAX(order_date) AS ref_date FROM orders_clean
),
activity AS (
  SELECT
    e.customer_id,
    COUNT(*) FILTER (WHERE e.event_type='session_start') AS sessions_90d,
    COUNT(*) FILTER (WHERE e.event_type='add_to_cart')   AS atc_90d,
    COUNT(*) FILTER (WHERE e.event_type='purchase')      AS purchase_events_90d
  FROM events e, ref
  WHERE e.event_time >= ref.ref_date - INTERVAL '90' DAY
  GROUP BY e.customer_id
),
agg AS (
  SELECT
    c.customer_id,
    COALESCE(a.sessions_90d,0)        AS sessions_90d,
    COALESCE(a.atc_90d,0)             AS atc_90d,
    COALESCE(a.purchase_events_90d,0) AS purchase_events_90d,
    COALESCE((
        SELECT SUM(oc.revenue)
        FROM orders_clean oc, ref
        WHERE oc.customer_id=c.customer_id
          AND oc.completed=1
          AND oc.order_date >= ref.ref_date - INTERVAL '365' DAY
    ),0) AS spend_365d,
    COALESCE((
        SELECT COUNT(*) FROM orders_clean oc
        WHERE oc.customer_id=c.customer_id AND oc.completed=1
    ),0) AS lifetime_orders,
    (SELECT MAX(oc.order_date) FROM orders_clean oc
     WHERE oc.customer_id=c.customer_id AND oc.completed=1) AS last_order_date
  FROM customers c
  LEFT JOIN activity a USING(customer_id)
)
SELECT
  a.*,
  CASE
    WHEN a.last_order_date IS NULL THEN 1
    WHEN datediff('day', a.last_order_date, (SELECT ref_date FROM ref)) > 90 THEN 1
    ELSE 0
  END AS churn_label
FROM agg a;
