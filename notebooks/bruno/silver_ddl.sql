-- Estrutura das tabelas Silver (bruno) em formato Delta, no Hive Metastore (base silver).
-- Só a estrutura: os dados são carregados pelo notebook 3.silver_marketing.ipynb (mode overwrite).
CREATE DATABASE IF NOT EXISTS silver LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/';

CREATE TABLE IF NOT EXISTS silver.marketing_funnel (
    `mql_id`                         STRING,
    `first_contact_date`             DATE,
    `contact_month`                  DATE,
    `landing_page_id`                STRING,
    `origin`                         STRING,
    `seller_id`                      STRING,
    `sdr_id`                         STRING,
    `sr_id`                          STRING,
    `won_date`                       TIMESTAMP,
    `business_segment`               STRING,
    `lead_type`                      STRING,
    `lead_behaviour_profile`         STRING,
    `has_company`                    BOOLEAN,
    `has_gtin`                       BOOLEAN,
    `average_stock`                  STRING,
    `business_type`                  STRING,
    `declared_product_catalog_size`  INT,
    `declared_monthly_revenue`       DOUBLE,
    `converted`                      INT
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/marketing_funnel/';

CREATE TABLE IF NOT EXISTS silver.ipca_mensal (
    `reference_month`  DATE,
    `ipca_rate_12m`    DOUBLE
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/ipca_mensal/';
