-- Estrutura das tabelas Silver (henrique) em formato Delta, no Hive Metastore (base silver).
-- Só a estrutura: os dados são carregados pelo notebook 3.silver_womens_rtr.ipynb (mode overwrite).
CREATE DATABASE IF NOT EXISTS silver LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/';

CREATE TABLE IF NOT EXISTS silver.wc_avaliacoes (
    `id_avaliacao`          INT,
    `clothing_id`           INT,
    `division_name`         STRING,
    `rating`                INT,
    `recomenda`             BOOLEAN,
    `avaliacao_negativa`    BOOLEAN,
    `avaliacao_incoerente`  BOOLEAN
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/wc_avaliacoes/';

CREATE TABLE IF NOT EXISTS silver.wc_produtos (
    `clothing_id`      INT,
    `division_name`    STRING,
    `department_name`  STRING,
    `class_name`       STRING
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/wc_produtos/';

CREATE TABLE IF NOT EXISTS silver.rtr_avaliacoes (
    `id_avaliacao_rtr`    INT,
    `item_id`             INT,
    `data_avaliacao`      DATE,
    `nota`                INT,
    `nota_5`              DOUBLE,
    `avaliacao_negativa`  BOOLEAN,
    `ajuste`              STRING
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/rtr_avaliacoes/';

CREATE TABLE IF NOT EXISTS silver.rtr_produtos (
    `item_id`          INT,
    `categoria`        STRING,
    `departamento_wc`  STRING
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/rtr_produtos/';
