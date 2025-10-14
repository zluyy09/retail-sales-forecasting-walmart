from datetime import datetime, timedelta
import os, duckdb
from airflow import DAG
from airflow.operators.python import PythonOperator

BASE = os.getenv("PROJECT_BASE", ".")

def load_to_duckdb(**context):
    con = duckdb.connect(os.path.join(BASE, "data/processed/warehouse.duckdb"))
    con.execute("CREATE SCHEMA IF NOT EXISTS analytics;")
    for name in ["customers","orders","order_items","products","events","campaigns","campaign_members"]:
        path = os.path.join(BASE, f"data/raw/{name}.csv")
        con.execute(f"CREATE OR REPLACE TABLE analytics.{name} AS SELECT * FROM read_csv_auto('{path}', SAMPLE_SIZE=-1);")
    con.close()

def run_sql(file_name, **context):
    con = duckdb.connect(os.path.join(BASE, "data/processed/warehouse.duckdb"))
    con.execute("SET schema='analytics';")
    sql_path = os.path.join(BASE, "sql", file_name)
    with open(sql_path,'r') as f:
        q = f.read()
    if file_name=='rfm.sql':
        con.execute("CREATE OR REPLACE VIEW rfm_view AS " + q)
    else:
        con.execute(q)
    con.close()

default_args = {"owner":"data","depends_on_past":False,"retries":1,"retry_delay":timedelta(minutes=5)}

with DAG("customer_analytics_pipeline", default_args=default_args, schedule_interval="@weekly",
         start_date=datetime(2024,1,1), catchup=False, tags=["analytics","rfm","churn"]) as dag:
    t1 = PythonOperator(task_id="load_to_duckdb", python_callable=load_to_duckdb)
    t2 = PythonOperator(task_id="rfm", python_callable=run_sql, op_kwargs={"file_name":"rfm.sql"})
    t3 = PythonOperator(task_id="segmentation", python_callable=run_sql, op_kwargs={"file_name":"segmentation.sql"})
    t4 = PythonOperator(task_id="churn_features", python_callable=run_sql, op_kwargs={"file_name":"churn_features.sql"})
    t5 = PythonOperator(task_id="clv_simple", python_callable=run_sql, op_kwargs={"file_name":"clv_simple.sql"})
    t1 >> [t2, t4, t5]; t2 >> t3
