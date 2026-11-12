# EDSTD - PROJETO

**Dataset:** [Electronic Products and Pricing Data - Datafiniti](https://www.kaggle.com/datasets/datafiniti/electronic-products-prices)

Ficheiro: `DatafinitiElectronicsProductsPricingData.csv` - 14 592 registos de preço, 1 245 produtos, 31 colunas (5 vazias). As 14 592 linhas têm 43 238 datas de observação (`prices.dateSeen`) entre maio de 2014 e julho de 2018, concentradas entre março de 2017 e junho de 2018.

**Datasets relacionados:**
- [Amazon Review Data 2018 - Electronics](https://cseweb.ucsd.edu/~jmcauley/datasets/amazon_v2/) (complementar, avaliações). 551 dos 1 245 produtos ligam: 500 pelo `asins` e mais 51 pelo `manufacturerNumber` + `brand`.
- [US Holiday Dates 2004-2021](https://www.kaggle.com/datasets/donnetew/us-holiday-dates-2004-2021) (complementar do Diogo, feriados dos EUA). Liga pela data.

**Período (decisão do grupo):** 01/01/2017 - 31/12/2018 (41 926 observações, 97 %). Datas em UTC na silver.

---

## Questões Analíticas

| #  | Questão                                                                 | Datasets           | Business Users/Stakeholders                  | Tabela Silver | Tabela Gold |
|----|-------------------------------------------------------------------------|--------------------|----------------------------------------------|---------------|-------------|
| Q1 | Os produtos mais baratos da sua categoria são pior avaliados na Amazon? | Preços + Amazon    | Departamento de Pricing / Gestão de Produto  |               |             |
| Q2 | Há mais promoções na época de festas do que no resto do ano?            | Preços + Feriados  | Departamento de Marketing / Pricing          |               |             |

### Q1

> Dentro da mesma categoria, os produtos com preço mais baixo nos retalhistas têm piores avaliações dos clientes na Amazon do que os mais caros, e as marcas conhecidas fogem a essa regra?

**Planeamento de execução**

1. Preços: separar `prices.dateSeen` numa linha por data, cortar para 2017-2018, só produtos novos (`prices.condition`) em USD (`prices.currency`).
2. Preços: calcular o preço mediano de cada produto (`prices.amountMin`) e normalizar `categories` para uma categoria principal.
3. Amazon: ratings sem duplicados e cortados para 2017-2018; meta sem `asin` repetidos.
4. Ligar pelo `asins` e, nos que não ligam, pelo `manufacturerNumber` + `brand`.
5. Dividir os produtos de cada categoria em escalões de preço (quartis) e calcular, por categoria × escalão (× marca), o rating médio e a % de avaliações negativas.

### Q2

> Os produtos eletrónicos entram em promoção com mais frequência e com descontos maiores na época de festas (Thanksgiving/Black Friday até ao Natal) do que no resto do ano, e isso varia por retalhista?

**Planeamento de execução**

1. Preços: separar `prices.dateSeen` numa linha por data, converter para data (UTC) e cortar para 2017-2018.
2. Preços: marcar promoção quando `prices.amountMin` < `prices.amountMax` (o `prices.isSale` não é fiável: 68,6 % das promoções não têm desconto) e calcular a % de desconto.
3. Preços: normalizar `prices.merchant` (ex.: "Bestbuy.com" / "Best Buy").
4. Feriados: definir a época de festas a partir das datas de Thanksgiving e Natal de cada ano.
5. Ligar pela data e comparar, por retalhista, a taxa de promoção e o desconto médio dentro e fora da época de festas.

---

## Key Performance Indicators (KPI)

| #  | KPI                               | Questão | Business Users/Stakeholders                 |
|----|-----------------------------------|---------|---------------------------------------------|
| K1 | Taxa de avaliações negativas      | Q1      | Departamento de Pricing / Gestão de Produto |
| K2 | Taxa de promoção na época de festas | Q2    | Departamento de Marketing / Pricing         |

### K1 - Taxa de avaliações negativas

**Cálculo:** (nº de avaliações com `overall` ≤ 2 ÷ nº total de avaliações) × 100, por categoria e escalão de preço.

| Target        | Avaliação  |
|---------------|------------|
| ≤ 10 %        | Bom        |
| ]10 %, 20 %]  | Razoável   |
| > 20 %        | Mau        |

### K2 - Taxa de promoção na época de festas

**Cálculo:** (nº de observações com `prices.amountMin` < `prices.amountMax` na época de festas ÷ nº total de observações na época de festas) × 100, por retalhista, comparada com a mesma taxa no resto do ano.

| Target                                   | Avaliação                       |
|------------------------------------------|---------------------------------|
| ≥ 1,5 × a taxa do resto do ano           | Bom (aproveita a época)         |
| [1 ×, 1,5 ×[                             | Razoável                        |
| < 1 × a taxa do resto do ano             | Mau (não faz promoções na época)|
