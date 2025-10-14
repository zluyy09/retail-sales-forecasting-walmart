# System Design (Analytics Stack)

**Objective**: Build a reliable pipeline to compute RFM segments, churn risk, and CLV‑like metrics weekly and surface them to Marketing and CRM.

## Data Model (analytics-friendly)
- **customers(customer_id, signup_date, channel, region, age, gender)**
- **orders(order_id, customer_id, order_date, status, revenue)**
- **order_items(order_id, product_id, qty, price)**
- **products(product_id, category, subcategory, brand)**
- **events(event_id, customer_id, event_time, event_type, session_id, device, channel)**
- **campaigns(campaign_id, name, channel, start_date, end_date, cost)**
- **campaign_members(campaign_id, customer_id, sent_at, opened_at, clicked_at, converted_order_id)**

## KPIs
- Retention rate (cohort-based), Re-activation, AOV, Frequency, CLV proxy
- Segment funnels (Awareness → Click → Add‑to‑Cart → Purchase)
- Marketing efficiency: CAC, ROAS, LTV:CAC

## Orchestration
- Airflow DAG: extract → load → transform (SQL) → export → QA → notify

## Snowflake vs Local
- Start with SQLite/DuckDB locally; switch to Snowflake by swapping the SQLAlchemy URI.
- Secrets via env vars: `SNOWFLAKE_USER`, `SNOWFLAKE_PASSWORD`, `SNOWFLAKE_ACCOUNT`, etc.
