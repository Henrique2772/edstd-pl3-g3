-- Estrutura das tabelas Silver (enzo) em formato Delta, no Hive Metastore (base silver).
-- Só a estrutura: os dados são carregados pelo notebook 2.silver_olist_inmet.ipynb (mode overwrite).
CREATE DATABASE IF NOT EXISTS silver LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/';

CREATE TABLE IF NOT EXISTS silver.olist_itens (
    `order_id`          STRING,
    `order_item_id`     INT,
    `data_compra`       DATE,
    `seller_id`         STRING,
    `product_id`        STRING,
    `categoria_pt`      STRING,
    `categoria_en`      STRING,
    `customer_id`       STRING,
    `cidade_cliente`    STRING,
    `estado_cliente`    STRING,
    `estado_encomenda`  STRING,
    `preco`             DECIMAL(10,2),
    `frete`             DECIMAL(10,2),
    `dias_entrega`      INT,
    `dias_atraso`       INT,
    `is_atrasada`       BOOLEAN
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/olist_itens/';

CREATE TABLE IF NOT EXISTS silver.olist_vendedores (
    `seller_id`     STRING,
    `cep_vendedor`  STRING,
    `cidade`        STRING,
    `estado`        STRING
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/olist_vendedores/';

CREATE TABLE IF NOT EXISTS silver.olist_avaliacoes (
    `review_id`       STRING,
    `order_id`        STRING,
    `data_criacao`    DATE,
    `estado_cliente`  STRING,
    `nota`            INT,
    `is_negativa`     BOOLEAN,
    `dias_resposta`   INT
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/olist_avaliacoes/';

CREATE TABLE IF NOT EXISTS silver.inmet_meteorologia_diaria (
    `estado`                        STRING,
    `data`                          DATE,
    `precipitacao_media_diaria_mm`  DECIMAL(8,2),
    `temperatura_media`             DECIMAL(6,2),
    `humidade_media`                DECIMAL(6,2),
    `n_estacoes`                    BIGINT
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/inmet_meteorologia_diaria/';
