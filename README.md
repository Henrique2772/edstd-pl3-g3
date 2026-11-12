# EDSTD — PL3, Grupo 3

**Análise e Otimização do Comércio Eletrónico.** Projeto de Engenharia de Dados para Suporte à Tomada de Decisão (UMinho): Data Lakehouse com as camadas Bronze, Silver e Gold sobre a stack HDFS + Hive Metastore + Spark (Jupyter) + Delta Lake.

## Intervalo de tempo comum

Todos os datasets com datas são filtrados na camada Silver para o intervalo **1 de junho a 31 de dezembro de 2017**. Se o grupo decidir outro intervalo, atualizem-no aqui e nos notebooks Silver.

## Datasets

| Elemento | Dataset principal | Dataset complementar |
|---|---|---|
| Gabriel Almeida | Global Superstore Data | World Data 2017 (Global Economic & Environmental Indicators) |
| Diogo Fernandes | DataCo Smart Supply Chain | US Holiday Dates (2004-2021) |
| Bruno Sousa | Marketing Funnel by Olist | Brazil Inflation Rates History |
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

Cada elemento trabalha só na sua subpasta, sempre com o nome em minúsculas: `bruno`, `diogo`, `enzo`, `gabriel`, `henrique` e `quevin` (ex.: `notebooks/gabriel/`). O modelo conjunto fica diretamente em `modelo/` (`modelo/modelo_grupo.drawio`).

Se enviarem ficheiros pelo site do GitHub (*Add file → Upload files*), entrem primeiro na vossa pasta (ex.: `notebooks/gabriel/`). Se carregarem no botão a partir da página principal, os ficheiros ficam na raiz do repositório.

## Modelo dimensional do grupo

O modelo do grupo está em `modelo/modelo_grupo.drawio` (abre-se em [draw.io](https://app.diagrams.net)). É uma **constelação**: as tabelas de factos de todos partilham as mesmas dimensões (dimensões conformes), que estão ao centro do diagrama.

**Dimensões partilhadas:**

| Dimensão | O que tem | Usada por |
|---|---|---|
| `dim_tempo` | um registo por dia do intervalo comum (chave `AAAAMMDD`); feriados dos EUA (US Holiday Dates) e IPCA do Brasil | todas as tabelas de factos |
| `dim_categoria` | área comum (ex.: Vestuário, Eletrónica, Mobiliário), categoria e subcategoria | `dim_produto`, `fact_venda` (Gabriel), `fact_lead` (Bruno, segmento de negócio) |
| `dim_produto` | produtos de todas as lojas (coluna `fonte`); a Datafiniti e a Amazon ligam-se pelo modelo, sem tabela ponte | avaliações, preços, itens do DataCo e da Olist |
| `dim_cliente` | clientes do DataCo e da Olist | avaliações da Olist, itens do DataCo e da Olist |
| `dim_vendedor` | retalhistas (Datafiniti) e vendedores da Olist | preços, itens da Olist, leads convertidas do Bruno |
| `dim_localizacao` | país (com os indicadores do World Data 2017) e estado | vendas, itens do DataCo e da Olist, meteorologia |

**Tabelas de factos:** `fact_avaliacao` (avaliações do Women's Clothing, Rent the Runway, Amazon e Olist, com a coluna `fonte`), `fact_preco`, `fact_venda`, `fact_lead`, `fact_meteorologia`, e as tabelas de itens `fact_item_encomenda` (DataCo) e `fact_item_olist` (Olist), que ficam separadas.

Nas tabelas Gold usem os mesmos nomes de tabelas e de colunas do modelo. Quando um valor não existe (ex.: avaliação sem data), usa-se o registo `-1` da dimensão.

## Regras

- **Não ponham os ficheiros de dados (CSV, JSON, Parquet) no repositório.** São grandes e o GitHub não aceita ficheiros com mais de 100 MB. O `.gitignore` já os exclui. Ponham só o link do dataset na tabela acima.
- Façam `git pull` antes de começar a trabalhar e `git push` no fim.
- Usem mensagens de commit curtas e claras (ex.: "Silver do DataCo: filtro jun-dez 2017").
