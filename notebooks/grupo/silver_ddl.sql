-- Estrutura das tabelas Silver (grupo) em formato Delta, no Hive Metastore (base silver).
-- Só a estrutura: os dados são carregados pelo notebook silver_mapas_grupo.ipynb (mode overwrite).
CREATE DATABASE IF NOT EXISTS silver LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/';

CREATE TABLE IF NOT EXISTS silver.mapa_categorias (
    `fonte`                STRING,
    `categoria_origem`     STRING,
    `subcategoria_origem`  STRING,
    `area`                 STRING,
    `categoria`            STRING,
    `subcategoria`         STRING
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/mapa_categorias/';

CREATE TABLE IF NOT EXISTS silver.paises (
    `fonte`            STRING,
    `nome_origem`      STRING,
    `pais`             STRING,
    `codigo_iso`       STRING,
    `tem_indicadores`  BOOLEAN
)
USING DELTA
LOCATION 'hdfs://hdfs-nn:9000/warehouse/silver.db/paises/';
