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
modelo/       modelos do grupo (dimensional, híbrido) e diagrama de pipelines; uma subpasta por elemento
notebooks/    notebooks Bronze, Silver e Gold: uma subpasta por elemento + grupo/ (tabelas de correspondência comuns)
relatorio/    relatórios e artefactos de qualidade (Word/Excel): uma subpasta por elemento
```

Cada elemento trabalha só na sua subpasta, sempre com o nome em minúsculas: `bruno`, `diogo`, `enzo`, `gabriel`, `henrique` e `quevin` (ex.: `notebooks/gabriel/`). O modelo conjunto fica diretamente em `modelo/` (`modelo/modelo_grupo.drawio`).

Se enviarem ficheiros pelo site do GitHub (*Add file → Upload files*), entrem primeiro na vossa pasta (ex.: `notebooks/gabriel/`). Se carregarem no botão a partir da página principal, os ficheiros ficam na raiz do repositório.

## Modelo dimensional do grupo

O modelo do grupo está em `modelo/modelo_grupo.drawio` (abre-se em [draw.io](https://app.diagrams.net)). É uma **constelação** com **7 tabelas de factos**, uma por processo de negócio, organizada por áreas de negócio e não por elemento do grupo:

1. **Vendas & Encomendas**: `fact_vendas_superstore` (Gabriel), `fact_encomendas_dataco` (Diogo) e `fact_itens_olist` (Enzo), separadas por serem processos de empresas diferentes.
2. **Marketing & Expansão**: `fact_funil_marketing` (Bruno).
3. **Produto & Preços**: `fact_precos` (Quévin), um registo por produto × retalhista × dia.
4. **Avaliações & Satisfação**: `fact_avaliacoes`, com as avaliações do Women's Clothing, do Rent the Runway, da Amazon e da Olist numa só tabela (`nota_5` na escala 1–5). A Olist avalia a encomenda (`order_id` liga à `fact_itens_olist`): fica com produto e categoria `-1` e com a localização do cliente.
5. **Contexto**: `fact_meteorologia_diaria` (INMET).

**Dimensões partilhadas** (a verde, na faixa central do diagrama):
- `dim_calendario`: chave `sk_calendario` no formato `AAAAMMDD` (ex.: `20170704`), um registo por dia do intervalo comum, com os feriados dos EUA (US Holiday Dates) e a chave do mês `sk_mes`. Só tem feriados dos EUA: é uma limitação assumida, porque não temos um dataset de feriados do Brasil;
- `dim_ipca_mensal` (Bruno): inflação do Brasil a 12 meses (`ipca_12m`), um registo por mês (`sk_mes` = `AAAAMM`), ligada à `dim_calendario`. Não é uma tabela de factos porque descreve o mês. **Só se interpreta em factos do Brasil e nunca se soma** (usar `AVG`/`MAX` por mês);
- `dim_categoria_produto`: área comum (ex.: Vestuário, Eletrónica, Mobiliário), categoria e subcategoria. As categorias de cada dataset são traduzidas na Silver por uma tabela `mapa_categorias` (`fonte`, `categoria_origem` → `area`, `categoria`, `subcategoria`);
- `dim_vendedor`: vendedores da Olist, usada pelos itens da Olist e pelas leads convertidas do Bruno (mesmo `seller_id`);
- `dim_localizacao`: país (com os indicadores do World Data 2017 e o código ISO) e estado; a coluna `nivel` indica se o registo é um país ou um estado. Os nomes dos países têm de ser normalizados na Silver;
- `dim_produto`: um registo por produto de origem (Women's Clothing, Rent the Runway, Datafiniti, Amazon), sem tabela ponte. `id_produto_comum` agrupa os produtos da Datafiniti e da Amazon ligados direta ou indiretamente (por asin ou por modelo); `tipo_ligacao` é a ligação mais forte do grupo (asin > modelo > sem par). No Women's Clothing, `codigo_original` = `clothing_id` + `divisao`.

Dimensões de uma só área:
- `dim_perfil_encomenda` (área 1, junk, usada pelo Superstore e pelo DataCo): modo de envio, mercado e estado da encomenda;
- `dim_perfil_lead` (área 2);
- `dim_retalhista` (área 3);
- `dim_perfil_avaliacao` (área 4, junk): `fonte`, `ajuste` (RTR), `recomendado` e `incoerente` (Women's Clothing: `Sim`/`Não`); nas fontes em que não se aplicam fica "Não aplicável".

Regras do modelo:
- cada tabela de factos liga ao calendário uma só vez; as outras datas e os atrasos ficam como medidas em dias;
- os identificadores da origem guardados no facto (`row_id`, `order_id`, `order_item_id`, `review_id`, `mql_id`) são dimensões degeneradas (etiqueta **DD**);
- `desconto_pct` (Superstore, taxa 0–1) e `desconto_valor` (DataCo, em dinheiro) são medidas diferentes;
- na `fact_itens_olist`, `dias_entrega`, `dias_atraso` e `is_atrasada` são da encomenda e repetem-se por item: contam-se com `COUNT(DISTINCT order_id)`;
- `precipitacao_media_diaria_mm` = total diário de cada estação, depois média entre as estações do estado;
- o Women's Clothing não tem data: fica com `sk_calendario = -1` e tem de ser filtrado nas análises temporais;
- os indicadores booleanos no Gold usam o prefixo `is_` (ex.: `flag_vendas_extremas` da Silver → `is_vendas_extremas`);
- não há dimensão de cliente, porque nenhuma pergunta analisa clientes.

As chaves usam o prefixo `sk_`. Valores desconhecidos usam o registo `-1` de cada dimensão (incluindo `dim_ipca_mensal`).

## Modelo híbrido (o que se implementa na Gold)

O enunciado pede que a Gold implemente o **modelo híbrido** (`modelo/modelo_hibrido.drawio`): as **dimensões conformes**
(partilhadas por mais de uma tabela de factos: calendário, IPCA, categoria, vendedor, localização, produto e perfil de
encomenda) ficam como tabelas próprias; as dimensões usadas por **uma só** tabela de factos são **desnormalizadas** nessa
tabela (atributos marcados **DN** no diagrama):
- `dim_perfil_lead` → colunas `origem`, `lead_type`, `lead_behaviour_profile`, `business_type` na `fact_funil_marketing`;
- `dim_retalhista` → coluna `retalhista` na `fact_precos`;
- `dim_perfil_avaliacao` → colunas `fonte`, `ajuste`, `recomendado`, `incoerente` na `fact_avaliacoes`.

## Pipelines

O caminho dos dados está em `modelo/diagrama_pipelines.drawio`: ficheiros originais → **Bronze** (notebook `*bronze_*`:
HDFS `/projeto/bronze/<nome>/` e tabelas Delta `bronze.*`, dados tal como vêm) → **Silver** (notebook `*silver_*`:
limpeza, tipos e filtro 2017-06-01 a 2017-12-31; tabelas Delta `silver.*`) → **Gold** (modelo híbrido) → dashboards.

Ordem de execução: os notebooks Bronze e Silver de cada elemento e, no fim, `notebooks/grupo/silver_mapas_grupo.ipynb`,
que lê as Silver de todos e cria `silver.mapa_categorias` (categorias de cada fonte → área e categoria comuns) e
`silver.paises` (nomes de países de cada fonte → nome do World Data e código ISO).

Os ficheiros de dados ficam em `work/data/<nome>/` no Jupyter (não vão para o GitHub).

## Regras

- **Não ponham os ficheiros de dados (CSV, JSON, Parquet) no repositório.** São grandes e o GitHub não aceita ficheiros com mais de 100 MB. O `.gitignore` já os exclui. Ponham só o link do dataset na tabela acima.
- Façam `git pull` antes de começar a trabalhar e `git push` no fim.
- Usem mensagens de commit curtas e claras (ex.: "Silver do DataCo: filtro jun-dez 2017").
