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
- `dim_localizacao`: país (com os indicadores do World Data 2017 e o código ISO) e estado; a coluna `nivel` indica se o registo é um país ou um estado. Os nomes dos países de cada fonte já estão normalizados na `silver.paises` (nome do World Data + código ISO);
- `dim_produto`: um registo por produto de origem (Women's Clothing, Rent the Runway, Datafiniti, Amazon), sem tabela ponte. `id_produto_comum` agrupa os produtos da Datafiniti e da Amazon ligados direta ou indiretamente (por asin ou por modelo); `tipo_ligacao` é a ligação mais forte do grupo (asin > modelo > sem par). No Women's Clothing, `codigo_original` = `clothing_id` + `divisao`.

- `dim_perfil_encomenda` (junk, partilhada pelo Superstore e pelo DataCo): modo de envio, mercado (as duas fontes usam os mesmos mercados; "Asia Pacific" = "Pacific Asia") e estado da encomenda.

Dimensões de uma só área:
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

Notas de implementação (Silver → Gold):
- **Categorias:** a `dim_categoria_produto` é carregada a partir da `silver.mapa_categorias`. A conformidade está nos níveis `area` e `categoria`; a `subcategoria` fica com o texto da origem (ex.: "Bookcases", "cool_stuff"), para não se perder o detalhe de cada fonte.
- **Tipos:** a Silver guarda os valores monetários como `DOUBLE` em algumas tabelas (ex.: `vendas` e `lucro` do Superstore e do DataCo) e contagens como `BIGINT`; o cast para `DECIMAL`/`INT` do modelo é feito no Gold.
- **Valores desconhecidos na Silver:** ficam NULL, exceto a origem das leads do Bruno, que vem como `"unknown"`; no Gold ambos passam ao registo `-1` (ou ao texto "Desconhecido" nos atributos desnormalizados).
- **IPCA:** o ficheiro do Kaggle é atualizado todos os meses (393 ou 394 meses conforme a data do download); a Silver só usa os 7 meses de junho a dezembro de 2017.

## Modelo híbrido (o que se implementa na Gold)

O enunciado pede que a Gold implemente o **modelo híbrido** (`modelo/modelo_hibrido.drawio`): as **dimensões conformes**
(partilhadas por mais de uma tabela de factos: calendário, IPCA, categoria, vendedor, localização, produto e perfil de
encomenda) ficam como tabelas próprias; as dimensões usadas por **uma só** tabela de factos são **desnormalizadas** nessa
tabela (atributos marcados **DN** no diagrama):
- `dim_perfil_lead` → colunas `origem`, `lead_type`, `lead_behaviour_profile`, `business_type` na `fact_funil_marketing`;
- `dim_retalhista` → coluna `retalhista` na `fact_precos`;
- `dim_perfil_avaliacao` → colunas `fonte`, `ajuste`, `recomendado`, `incoerente` na `fact_avaliacoes`.

Nos atributos desnormalizados, o valor desconhecido é o texto "Desconhecido" (não há registo `-1`, porque não há dimensão).

A `dim_ipca_mensal` mantém-se como tabela própria, ligada à `dim_calendario` (outrigger): o IPCA é um valor por **mês**
e o calendário é por **dia**; pô-lo na `dim_calendario` repetiria o mesmo valor em ~30 linhas por mês e misturaria um
indicador do Brasil com um calendário partilhado por dados dos EUA, Europa e Ásia. Assim fica conforme, através do
calendário, para qualquer tabela de factos com data.

## Pipelines

O caminho dos dados está em `modelo/diagrama_pipelines.drawio`: ficheiros originais → **Bronze** (notebook `*bronze_*`:
HDFS `/projeto/bronze/<nome>/` e tabelas Delta `bronze.*`, dados tal como vêm) → **Silver** (notebook `*silver_*`:
limpeza, tipos e filtro 2017-06-01 a 2017-12-31; tabelas Delta `silver.*`) → **Gold** (modelo híbrido) → dashboards.

Ordem de execução: os notebooks Bronze e Silver de cada elemento e, no fim, `notebooks/grupo/silver_mapas_grupo.ipynb`,
que lê as Silver de todos e cria `silver.mapa_categorias` (categorias de cada fonte → área e categoria comuns) e
`silver.paises` (nomes de países de cada fonte → nome do World Data e código ISO).

Os ficheiros de dados ficam em `work/data/<nome>/` no Jupyter (o Bruno usa `work/` diretamente) e não vão para o GitHub.

Tabelas Silver do Henrique: `silver.wc_avaliacoes`, `silver.wc_produtos` (Women's Clothing), `silver.rtr_avaliacoes`, `silver.rtr_produtos` (Rent the Runway) e `silver.feriados_eua`.

## Regras

- **Não ponham os ficheiros de dados (CSV, JSON, Parquet) no repositório.** São grandes e o GitHub não aceita ficheiros com mais de 100 MB. O `.gitignore` já os exclui. Ponham só o link do dataset na tabela acima.
- Façam `git pull` antes de começar a trabalhar e `git push` no fim.
- Usem mensagens de commit curtas e claras (ex.: "Silver do DataCo: filtro jun-dez 2017").
