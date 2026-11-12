# EDSTD — PL3, Grupo 3

**Análise e Otimização do Comércio Eletrónico.** Projeto de Engenharia de Dados para Suporte à Tomada de Decisão (UMinho): Data Lakehouse com as camadas Bronze, Silver e Gold sobre a stack HDFS + Hive Metastore + Spark (Jupyter) + Delta Lake.

## Intervalo de tempo comum

Todos os datasets com datas são filtrados na camada Silver para o intervalo **1 de junho a 31 de dezembro de 2017**. Se o grupo decidir outro intervalo, atualizem-no aqui e nos notebooks Silver.

## Datasets

| Elemento | Dataset principal | Dataset complementar |
|---|---|---|
| Gabriel Almeida | Global Superstore Data | *a preencher* |
| Diogo Fernandes | DataCo Smart Supply Chain | US Holiday Dates (2004-2021) |
| Bruno Sousa | Marketing Funnel by Olist | *a preencher* |
| Quévin Gonçalves | Electronic Products and Pricing Data | Amazon Review Data (2018) |
| Enzo Silva | Brazilian E-Commerce (Olist) | Brazil temperature 2012-2019 |
| Henrique Oliveira | [Women's E-Commerce Clothing Reviews](https://www.kaggle.com/datasets/nicapotato/womens-ecommerce-clothing-reviews) | [Rent the Runway](https://www.kaggle.com/datasets/rmisra/clothing-fit-dataset-for-size-recommendation) + [US Holiday Dates](https://www.kaggle.com/datasets/donnetew/us-holiday-dates-2004-2021) |

Corrijam a vossa linha se estiver incompleta ou errada.

## Organização

```
modelo/       modelo dimensional (Gold): o modelo do grupo e uma subpasta por elemento
notebooks/    notebooks Bronze, Silver e Gold: uma subpasta por elemento
relatorio/    relatórios e artefactos de qualidade (Word/Excel): uma subpasta por elemento
```

Cada elemento trabalha só na sua subpasta (por exemplo, `notebooks/henrique/`). O modelo conjunto fica diretamente em `modelo/`.

## Modelo dimensional do grupo

O modelo do grupo deve ser uma **constelação**: as tabelas de factos de cada elemento partilham dimensões comuns (dimensões conformes). A dimensão a partilhar por todos é a **`dim_tempo`**:

- chave `id_tempo` no formato `AAAAMMDD` (ex.: `20170704`);
- um registo por dia do intervalo comum;
- atributos: data, dia, dia da semana, início da semana, mês, trimestre, ano e feriado (do US Holiday Dates).

O modelo parcial do Henrique está em `modelo/henrique/DER_Henrique.png`.

## Regras

- **Não ponham os ficheiros de dados (CSV, JSON, Parquet) no repositório.** São grandes e o GitHub não aceita ficheiros com mais de 100 MB. O `.gitignore` já os exclui. Ponham só o link do dataset na tabela acima.
- Façam `git pull` antes de começar a trabalhar e `git push` no fim.
- Usem mensagens de commit curtas e claras (ex.: "Silver do DataCo: filtro jun-dez 2017").
