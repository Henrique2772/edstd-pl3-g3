# EDSTD - PROJETO

**Dataset:** [Amazon Review Data 2018 - Electronics](https://cseweb.ucsd.edu/~jmcauley/datasets/amazon_v2/) (Ni, Li & McAuley, EMNLP 2019)

Ficheiros (2):
- `Electronics.csv` (ratings) - 20 994 353 avaliações, 4 colunas (`asin`, `reviewerID`, `overall`, `unixReviewTime`), sem cabeçalho, entre dezembro de 1997 e outubro de 2018 (4 650 749 em 2017-2018).
- `meta_Electronics.json` (metadados) - 786 445 produtos em JSON Lines, 19 colunas (título, marca, categorias, preço, ranking…).

**Dataset principal:** [Electronic Products and Pricing Data - Datafiniti](https://www.kaggle.com/datasets/datafiniti/electronic-products-prices) (preços). 551 dos 1 245 produtos ligam à Amazon: 500 pelo `asins` e mais 51 pelo modelo (`manufacturerNumber`) + `brand`.

**Período (decisão do grupo):** 01/01/2017 - 31/12/2018. Datas tratadas na silver em UTC; o `unixReviewTime` é sempre 00:00 UTC e é tratado como data.

---

## Questões Analíticas

| #  | Questão                                                                 | Datasets         | Business Users/Stakeholders                        | Tabela Silver | Tabela Gold |
|----|-------------------------------------------------------------------------|------------------|----------------------------------------------------|---------------|-------------|
| Q1 | Os produtos mais baratos da sua categoria são pior avaliados na Amazon? | Preços + Amazon  | Departamento de Pricing / Gestão de Produto        |               |             |

### Q1

> Dentro da mesma categoria, os produtos com preço mais baixo nos retalhistas têm piores avaliações dos clientes na Amazon do que os mais caros, e as marcas conhecidas fogem a essa regra?

**Planeamento de execução**

1. Ratings: dar nomes às 4 colunas, remover linhas duplicadas, converter `unixReviewTime` para data e cortar para 2017-2018.
2. Meta: ficar com `asin`, `title`, `brand`, `main_cat`, `category`; remover `asin` repetidos e limpar `&amp;` e marcas inválidas ("Generic", "Visit Amazon's…").
3. Preços: separar `prices.dateSeen` numa linha por data, cortar para 2017-2018, só produtos novos em USD; preço mediano de cada produto (`prices.amountMin`).
4. Ligar preços → Amazon pelo `asins` e, nos que não ligam, pelo `manufacturerNumber` + `brand` procurados no `title`/`brand` do meta.
5. Normalizar `categories` para uma categoria principal (TV, Áudio, Câmaras, Computadores…) e dividir os produtos de cada categoria em escalões de preço (quartis).
6. Por categoria × escalão de preço (× marca), calcular o rating médio e a % de avaliações negativas (`overall` ≤ 2).

---

## Key Performance Indicators (KPI)

| #  | KPI                              | Questão | Business Users/Stakeholders                 |
|----|----------------------------------|---------|---------------------------------------------|
| K1 | Taxa de avaliações negativas     | Q1      | Departamento de Pricing / Gestão de Produto |

### K1 - Taxa de avaliações negativas

**Cálculo:** (nº de avaliações com `overall` ≤ 2 ÷ nº total de avaliações) × 100, por categoria e escalão de preço.

| Target        | Avaliação  |
|---------------|------------|
| ≤ 10 %        | Bom        |
| ]10 %, 20 %]  | Razoável   |
| > 20 %        | Mau        |
