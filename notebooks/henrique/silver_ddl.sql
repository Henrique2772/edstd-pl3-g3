-- Estrutura das tabelas Silver (henrique) em formato Delta, no Hive Metastore (base silver).
-- Só a estrutura: os dados são carregados pelo notebook 3.silver_womens_rtr.ipynb (mode overwrite).
CREATE DATABASE IF NOT EXISTS silver LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/';

CREATE TABLE IF NOT EXISTS silver.avaliacoes (
    `id_avaliacao`          INT,
    `clothing_id`           INT,
    `division_name`         STRING,
    `rating`                INT,
    `recomenda`             BOOLEAN,
    `avaliacao_negativa`    BOOLEAN,
    `avaliacao_incoerente`  BOOLEAN
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/avaliacoes/';

CREATE TABLE IF NOT EXISTS silver.produtos (
    `clothing_id`      INT,
    `division_name`    STRING,
    `department_name`  STRING,
    `class_name`       STRING
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/produtos/';

CREATE TABLE IF NOT EXISTS silver.avaliacoes_rtr (
    `id_avaliacao_rtr`    INT,
    `item_id`             INT,
    `data_avaliacao`      DATE,
    `nota`                INT,
    `nota_5`              DOUBLE,
    `avaliacao_negativa`  BOOLEAN,
    `ajuste`              STRING
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/avaliacoes_rtr/';

CREATE TABLE IF NOT EXISTS silver.produtos_rtr (
    `item_id`          INT,
    `categoria`        STRING,
    `departamento_wc`  STRING
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/produtos_rtr/';

CREATE TABLE IF NOT EXISTS silver.feriados (
    `data`     DATE,
    `feriado`  STRING
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/feriados/';
