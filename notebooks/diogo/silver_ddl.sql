-- Estrutura das tabelas Silver (diogo) em formato Delta, no Hive Metastore (base silver).
-- Só a estrutura: os dados são carregados pelo notebook 2.silver_dataco.ipynb (mode overwrite).
CREATE DATABASE IF NOT EXISTS silver LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/';

CREATE TABLE IF NOT EXISTS silver.dataco_itens (
    `category_name`                STRING,
    `type`                         STRING,
    `days_for_shipping_real`       INT,
    `days_for_shipment_scheduled`  INT,
    `late_delivery_risk`           INT,
    `customer_id`                  INT,
    `customer_segment`             STRING,
    `department_id`                INT,
    `department_name`              STRING,
    `market`                       STRING,
    `order_city`                   STRING,
    `order_country`                STRING,
    `order_date`                   TIMESTAMP,
    `order_id`                     INT,
    `order_item_discount`          DOUBLE,
    `order_item_id`                INT,
    `order_item_product_price`     DOUBLE,
    `order_item_quantity`          INT,
    `sales`                        DOUBLE,
    `order_item_total`             DOUBLE,
    `order_profit_per_order`       DOUBLE,
    `order_region`                 STRING,
    `order_state`                  STRING,
    `order_status`                 STRING,
    `product_card_id`              INT,
    `product_name`                 STRING,
    `shipping_date`                TIMESTAMP,
    `shipping_mode`                STRING,
    `category_id`                  INT,
    `data_encomenda`               DATE
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/dataco_itens/';
