-- Estrutura das tabelas Silver (gabriel) em formato Delta, no Hive Metastore (base silver).
-- Só a estrutura: os dados são carregados pelo notebook 2.silver_superstore_worlddata.ipynb (mode overwrite).
CREATE DATABASE IF NOT EXISTS silver LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/';

CREATE TABLE IF NOT EXISTS silver.superstore_vendas (
    `row_id`                INT,
    `order_id`              STRING,
    `data_encomenda`        DATE,
    `data_envio`            DATE,
    `modo_envio`            STRING,
    `mercado`               STRING,
    `regiao`                STRING,
    `pais`                  STRING,
    `estado`                STRING,
    `cidade`                STRING,
    `categoria`             STRING,
    `subcategoria`          STRING,
    `product_id`            STRING,
    `quantidade`            INT,
    `vendas`                DOUBLE,
    `desconto_pct`          DOUBLE,
    `lucro`                 DOUBLE,
    `custo_envio`           DOUBLE,
    `prioridade_encomenda`  STRING,
    `is_vendas_extremas`    BOOLEAN,
    `is_lucro_extremo`      BOOLEAN,
    `is_desconto_alto`      BOOLEAN,
    `is_prejuizo`           BOOLEAN
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/superstore_vendas/';

CREATE TABLE IF NOT EXISTS silver.world_data_2017 (
    `pais`                 STRING,
    `codigo_iso`           STRING,
    `ano`                  INT,
    `pib_usd`              DECIMAL(20,0),
    `populacao`            BIGINT,
    `taxa_desemprego_pct`  DECIMAL(5,1),
    `emissoes_co2_kt`      BIGINT
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/world_data_2017/';
