-- Estrutura das tabelas Silver (quevin) em formato Delta, no Hive Metastore (base silver).
-- Só a estrutura: os dados são carregados pelo notebook 2.silver_electronics.ipynb (mode overwrite).
CREATE DATABASE IF NOT EXISTS silver LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/';

CREATE TABLE IF NOT EXISTS silver.amazon_avaliacoes (
    `asin`            STRING,
    `reviewer_id`     STRING,
    `nota`            INT,
    `data_avaliacao`  DATE
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/amazon_avaliacoes/';

CREATE TABLE IF NOT EXISTS silver.amazon_produtos (
    `asin`                 STRING,
    `nome`                 STRING,
    `marca`                STRING,
    `categoria_principal`  STRING,
    `subcategoria`         STRING,
    `caminho_categoria`    STRING,
    `preco_lista`          DECIMAL(10,2),
    `data_lancamento`      DATE,
    `ranking_vendas`       INT
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/amazon_produtos/';

CREATE TABLE IF NOT EXISTS silver.datafiniti_precos (
    `product_id`             STRING,
    `retalhista`             STRING,
    `data`                   DATE,
    `preco_min`              DECIMAL(10,2),
    `preco_max`              DECIMAL(10,2),
    `is_promocao_anunciada`  BOOLEAN,
    `is_desconto`            BOOLEAN,
    `desconto_pct`           DECIMAL(5,2)
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/datafiniti_precos/';

CREATE TABLE IF NOT EXISTS silver.datafiniti_produtos (
    `product_id`            STRING,
    `nome`                  STRING,
    `marca`                 STRING,
    `modelo`                STRING,
    `categoria_principal`   STRING,
    `categoria_datafiniti`  STRING,
    `categorias`            STRING,
    `asins`                 STRING
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/datafiniti_produtos/';

CREATE TABLE IF NOT EXISTS silver.datafiniti_amazon_ligacao (
    `product_id`    STRING,
    `asin`          STRING,
    `tipo_ligacao`  STRING
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/datafiniti_amazon_ligacao/';
