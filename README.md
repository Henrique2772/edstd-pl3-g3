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

O modelo do grupo está em `modelo/modelo_grupo.drawio` (abre-se em [draw.io](https://app.diagrams.net)). É uma **constelação** organizada por áreas de negócio, e não por elemento do grupo:

1. **Vendas & Encomendas**: `fact_vendas_superstore` (Gabriel), `fact_encomendas_dataco` (Diogo) e `fact_itens_olist` (Enzo), separadas por serem processos de empresas diferentes.
2. **Marketing & Expansão**: `fact_funil_marketing` (Bruno).
3. **Produto & Preços**: `fact_precos` (Quévin), com os produtos da Datafiniti e da Amazon na mesma `dim_produto` (sem tabela ponte).
4. **Avaliações & Satisfação**: `fact_avaliacoes`, com as avaliações do Women's Clothing, do Rent the Runway, da Amazon e da Olist numa só tabela (coluna `fonte`).
5. **Contexto**: `fact_macro_mensal` (IPCA) e `fact_meteorologia_diaria` (INMET).

**Dimensões partilhadas** (a vermelho no diagrama):
- `dim_calendario`: chave `sk_calendario` no formato `AAAAMMDD` (ex.: `20170704`), um registo por dia do intervalo comum, com os feriados dos EUA (US Holiday Dates);
- `dim_categoria_produto`: área comum (ex.: Vestuário, Eletrónica, Mobiliário), categoria e subcategoria, usada pelas vendas, encomendas, leads, preços e avaliações;
- `dim_vendedor`: vendedores da Olist, usada pelos itens da Olist e pelas leads convertidas do Bruno (mesmo `seller_id`);
- `dim_localizacao`: país (com os indicadores do World Data 2017) e estado;
- `dim_produto`: peças de roupa (Women's Clothing, Rent the Runway) e eletrónicos (Datafiniti e Amazon), partilhada pelas áreas 3 e 4.

Dimensões de uma só área: `dim_modo_envio` (área 1), `dim_perfil_lead` (origem e perfil da lead, área 2) e `dim_retalhista` (área 3). O modelo só tem as ligações de que as perguntas analíticas precisam: cada tabela de factos liga ao calendário uma só vez (as outras datas e os atrasos ficam como medidas em dias) e não há dimensão de cliente, porque nenhuma pergunta analisa clientes.

As chaves usam o prefixo `sk_`. Valores desconhecidos usam o registo `-1` de cada dimensão.

## Regras

- **Não ponham os ficheiros de dados (CSV, JSON, Parquet) no repositório.** São grandes e o GitHub não aceita ficheiros com mais de 100 MB. O `.gitignore` já os exclui. Ponham só o link do dataset na tabela acima.
- Façam `git pull` antes de começar a trabalhar e `git push` no fim.
- Usem mensagens de commit curtas e claras (ex.: "Silver do DataCo: filtro jun-dez 2017").
