/*Consultas do projeto Risco Relativo*/

//Processar e preparar a base de dados
/*Identificar E Gerenciar Valores Nulos*/

-- Identificar a quantidade de registros nulos na variável last_month_salary
SELECT COUNT(*) AS total_registros_nulos
FROM `riscorelativo.projeto03.user_info`
WHERE last_month_salary IS NULL;

-- Verificar os valores nulos na coluna default_flag da tabela default
SELECT COUNT(*) AS total_registros_nulos
FROM riscorelativo.projeto03.default
WHERE default_flag IS NULL;

-- Verificar os valores nulos da tabela default (não tem nulos/total de 36000 registros)
SELECT 
    COUNT(*) AS total_registros,
    COUNT(CASE WHEN user_id IS NULL THEN 1 END) AS null_user_id,
    COUNT(CASE WHEN default_flag IS NULL THEN 1 END) AS null_default_flag
FROM riscorelativo.projeto03.default;

-- Verificar os valores nulos da tabela loans_detail
SELECT 
    COUNT(*) AS total_registros,
    COUNT(CASE WHEN user_id IS NULL THEN 1 END) AS null_user_id,
    COUNT(CASE WHEN more_90_days_overdue IS NULL THEN 1 END) AS null_more_90_days_overdue,
    COUNT(CASE WHEN using_lines_not_secured_personal_assets IS NULL THEN 1 END) AS null_using_lines_not_secured_personal_assets,
    COUNT(CASE WHEN number_times_delayed_payment_loan_30_59_days IS NULL THEN 1 END) AS null_number_times_delayed_payment_loan_30_59_days,
    COUNT(CASE WHEN debt_ratio IS NULL THEN 1 END) AS null_debt_ratio,
    COUNT(CASE WHEN number_times_delayed_payment_loan_60_89_days IS NULL THEN 1 END) AS number_times_delayed_payment_loan_60_89_days
FROM riscorelativo.projeto03.loans_detail;


-- Verificar os valores nulos da tabela loans_outstanding
SELECT 
    COUNT(*) AS total_registros,
    COUNT(CASE WHEN loan_id IS NULL THEN 1 END) AS null_loan_id,
    COUNT(CASE WHEN user_id IS NULL THEN 1 END) AS null_user_id,
    COUNT(CASE WHEN loan_type IS NULL THEN 1 END) AS null_loan_type
FROM riscorelativo.projeto03.loans_outstanding;


-- Verificar os valores nulos da tabela user_info
SELECT 
    COUNT(*) AS total_registros,
    COUNT(CASE WHEN user_id IS NULL THEN 1 END) AS null_user_id,
    COUNT(CASE WHEN age IS NULL THEN 1 END) AS null_age,
    COUNT(CASE WHEN sex IS NULL THEN 1 END) AS null_sex,
    COUNT(CASE WHEN last_month_salary IS NULL THEN 1 END) AS null_last_month_salary,
    COUNT(CASE WHEN number_dependents IS NULL THEN 1 END) AS null_number_dependents
FROM riscorelativo.projeto03.user_info;


/*Identificar E Gerenciar Valores Duplicados*/
-- Identificar dados duplicados na tabela riscorelativo.projeto03.default
SELECT user_id, default_flag, COUNT(*) AS total_ocorrencias
FROM riscorelativo.projeto03.default
GROUP BY user_id, default_flag
HAVING COUNT(*) > 1;

-- Identificar dados duplicados na tabela riscorelativo.projeto03.loans_detail
SELECT user_id, 
       more_90_days_overdue, 
       using_lines_not_secured_personal_assets, 
       number_times_delayed_payment_loan_30_59_days, 
       debt_ratio, 
       number_times_delayed_payment_loan_60_89_days
FROM riscorelativo.projeto03.loans_detail
GROUP BY user_id, 
         more_90_days_overdue, 
         using_lines_not_secured_personal_assets, 
         number_times_delayed_payment_loan_30_59_days, 
         debt_ratio, 
         number_times_delayed_payment_loan_60_89_days
HAVING COUNT(*) > 1;

-- Identificar dados duplicados na tabela riscorelativo.projeto03.loans_outstanding
SELECT user_id, 
       loan_id, 
       loan_type
FROM riscorelativo.projeto03.loans_outstanding
GROUP BY user_id, 
         loan_id, 
         loan_type
HAVING COUNT(*) > 1;

-- Identificar dados duplicados na tabela riscorelativo.projeto03.user_info
SELECT user_id, 
       age, 
       sex, 
       last_month_salary, 
       number_dependents
FROM riscorelativo.projeto03.user_info
GROUP BY user_id, 
         age, 
         sex, 
         last_month_salary, 
         number_dependents
HAVING COUNT(*) > 1;

--procurando duplicados
SELECT user_id, COUNT(*)
FROM riscorelativo.projeto03.loans_outstanding
GROUP BY user_id 
HAVING COUNT(*) > 1;


/*Identificar E Manejar Dados Fora Do Alcance Da Análise*/
--mediana last_month_salary e number_dependents
SELECT
   PERCENTILE_CONT(last_month_salary, 0.5) OVER () AS mediana_last_month_salary,
   PERCENTILE_CONT(number_dependents, 0.5) OVER () AS mediana_number_dependents,
   PERCENTILE_CONT(age, 0.5) OVER () AS mediana_age,
   FROM `riscorelativo.projeto03.user_info`


-- Verificar os valores nulos da tabela user_info_mediana
SELECT 
    COUNT(*) AS total_registros,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN sex IS NULL THEN 1 ELSE 0 END) AS null_sex,
    SUM(CASE WHEN last_month_salary IS NULL THEN 1 ELSE 0 END) AS null_last_month_salary,
    SUM(CASE WHEN number_dependents IS NULL THEN 1 ELSE 0 END) AS null_number_dependents
FROM riscorelativo.projeto03.user_info_mediana;


/*	Identificar E Gerir Dados Discrepantes Em Variáveis Categóricas*/
--alteração do valor da variavel loan_type
SELECT
  loan_id,
  user_id,
  CASE
    WHEN LOWER(loan_type) IN ('real estate', 'real estate') THEN 'Real Estate'
    WHEN LOWER(loan_type) IN ('other', 'other', 'others') THEN 'Other'
    ELSE loan_type
  END AS loan_type_corrigido
FROM
`riscorelativo.projeto03.loans_outstanding`;


/*Criar Novas Variáveis*/
--novas variaveis: total_loan, num_real_estate, num_other
SELECT
user_id,
COUNT(DISTINCT loan_id) AS total_loan,
SUM(CASE WHEN loan_type_corrigido = 'Real Estate' THEN 1 ELSE 0 END) AS num_real_estate,
SUM (CASE WHEN loan_type_corrigido = 'Other' THEN 1 ELSE 0 END) AS num_other,
FROM `riscorelativo.projeto03.loans_outstanding_type_corrigido`
GROUP BY
user_id;


/*Unir tabelas	LEFT JOIN*/
SELECT *
FROM riscorelativo.projeto03.user_info_mediana AS tp
LEFT JOIN riscorelativo.projeto03.default AS ts
ON tp.user_id = ts.user_id;
--user_id voltou repitido

--sem o novo user_id
SELECT user_id, age, sex, last_month_salary, number_dependents, default_flag
FROM riscorelativo.projeto03.user_info_default AS tp;

--exclusão da tabela com user_id repitido
DROP TABLE riscorelativo.projeto03.user_info_default_1;

---Join user_info_default + total_loan + loans_detail
--Create users_loans_full
CREATE TABLE `riscorelativo.projeto03.users_loans_full` AS
SELECT 
  u.user_id,
  u.age,
  u.last_month_salary,
  u.number_dependents,
  u.default_flag,
  l.more_90_days_overdue,
  l.using_lines_not_secured_personal_assets,
  l.number_times_delayed_payment_loan_30_59_days,
  l.debt_ratio,
  l.number_times_delayed_payment_loan_60_89_days,
  t.total_loan,
  t.num_real_estate,
  t.num_other
FROM 
  `riscorelativo.projeto03.user_info_default` u
LEFT JOIN
  `riscorelativo.projeto03.loans_detail` l
ON
  u.user_id = l.user_id
LEFT JOIN
  `riscorelativo.projeto03.total_loan` t
ON
  u.user_id = t.user_id;


/*Identificar E Manejar Dados Fora Do Alcance Da Análise*/
--consultar os nulls após o join
SELECT
COUNTIF(total_loan IS NULL) AS nulls_total_loan,
COUNTIF (num_real_estate IS NULL) AS num_real_estate,
COUNTIF (num_other IS NULL) AS num_other
FROM `riscorelativo.projeto03.users_loans_full`

/*Construir Tabelas Auxiliares*/
--CREATE VIEW `riscorelativo.projeto03.view_nulls` AS
SELECT
  COUNTIF(total_loan IS NULL) AS nulls_total_loan,
  COUNTIF(num_real_estate IS NULL) AS num_real_estate,
  COUNTIF(num_other IS NULL) AS num_other
FROM
  `riscorelativo.projeto03.users_loans_full`;


--consulta table full e nulls após join (425)
--CREATE VIEW `riscorelativo.projeto03.view_fulltable_nulls` AS
SELECT * FROM `riscorelativo.projeto03.users_loans_full`
WHERE total_loan IS NULL;

--nulls
SELECT
  COUNTIF(total_loan IS NULL) AS nulls_total_loan,
  COUNTIF(num_real_estate IS NULL) AS num_real_estate,
  COUNTIF(num_other IS NULL) AS num_other
FROM
  `riscorelativo.projeto03.users_loans_full`

--sem 425 nulls de total_loan, num_real_estate e num_other
CREATE OR REPLACE TABLE riscorelativo.projeto03.users_loans_full_semnulls AS
SELECT 
    user_id,
    age,
    last_month_salary,
    number_dependents,
    default_flag,
    more_90_days_overdue,
    using_lines_not_secured_personal_assets,
    number_times_delayed_payment_loan_30_59_days,
    debt_ratio,
    number_times_delayed_payment_loan_60_89_days,
    total_loan,
    num_real_estate,
    num_other
FROM 
    riscorelativo.projeto03.users_loans_full
WHERE 
    total_loan IS NOT NULL
    AND num_real_estate IS NOT NULL
    AND num_other IS NOT NULL;


/*Identificar E Gerenciar Dados Discrepantes Em Variáveis Numéricas*/
--tratar dados discrepantes em variáveis ​​numéricas (variável last_month_salary do tipo FLOAT)
SELECT * FROM   `riscorelativo.projeto03.user_info`
WHERE last_month_salary = 1.00E+05

/*	Verificar E Alterar Tipo De Dado*/
--last_month_salary do tipo FLOAT para INTENGER
CREATE TABLE `riscorelativo.projeto03.user_info_new` AS
SELECT 
  user_id,
  age,
  sex,
  CAST(last_month_salary AS INT64) AS last_month_salary,
  number_dependents
FROM 
  `riscorelativo.projeto03.user_info`;

/*Calcular Correlação Entre Variáveis*/
//correlação entre variáveis de atraso de pagamento
SELECT
CORR (more_90_days_overdue, number_times_delayed_payment_loan_30_59_days) AS more90days_3059days_corr,
CORR (more_90_days_overdue, number_times_delayed_payment_loan_60_89_days) AS more90days_6089days_corr,
CORR (number_times_delayed_payment_loan_30_59_days, number_times_delayed_payment_loan_60_89_days) AS _3059days_6089days_corr,
FROM `riscorelativo.projeto03.loans_detail`

--7105 overdue = 1
SELECT
  user_id,
  age,
  last_month_salary,
  number_dependents,
  default_flag,
  more_90_days_overdue,
  using_lines_not_secured_personal_assets,
  number_times_delayed_payment_loan_30_59_days,
  debt_ratio,
  number_times_delayed_payment_loan_60_89_days,
  total_loan,
  num_real_estate,
  num_other,
  overdue
FROM
  `riscorelativo.projeto03.users_loans_full_semnulls_with_overdue`
WHERE
  overdue = 1;


--correlação entre variáveis numéricas
SELECT
CORR (age_quintile, last_month_salary_quintile) AS age_salary_corr,
CORR (age_quintile, lines_not_secured_quintile) AS age_lines_corr,
CORR (age_quintile, total_loans_quintile ) AS age_loans_corr,
CORR (age_quintile, debt_ratio_quintile) AS age_debt_corr,
CORR (age_quintile, has_delay) AS age_delay,
CORR (age_quintile, has_dependents) AS age_dependents_corr,
CORR (last_month_salary_quintile, has_delay) AS salary_delay_corr,
CORR (last_month_salary_quintile, debt_ratio_quintile) AS salary_ratio_corr,
CORR (last_month_salary_quintile, total_loans_quintile) AS salary_loans_corr,
CORR (age_quintile, default_flag) AS age_flag_corr,
CORR (last_month_salary_quintile, default_flag) AS salary_flag_corr,
CORR (total_loans_quintile, default_flag) AS loans_flag_corr,
CORR (debt_ratio_quintile, default_flag) AS ratio_flag_corr,
CORR (has_delay, default_flag) AS delay_flag_corr,
CORR (has_dependents, default_flag) AS dependents_flag_corr
from `riscorelativo.projeto03.users_loans_full`



/*	Calcular Quartis, Decis Ou Percentis*/
--Calcular os quartis pra esse grupos: idade (age), salário (last_month_salary), número de dependentes (number_dependents)
--Calcular quartis para variáveis ​​de risco relativo com a função PERCENTILE_CONT
--Quartis para a variável age
--Calcular os Quartis
CREATE OR REPLACE TABLE `riscorelativo.projeto03.age_quartiles` AS
SELECT
  PERCENTILE_CONT(age, 0.25) OVER() AS q1,
  PERCENTILE_CONT(age, 0.50) OVER() AS q2,
  PERCENTILE_CONT(age, 0.75) OVER() AS q3
FROM
  `riscorelativo.projeto03.users_loans_full`;


--Aplicar técnica de análise
/*Calcular Risco Relativo*/
--Risco Relativo de Idade
CREATE VIEW riscorelativo.projeto03.riscorelativo_idade 
--calcular os quartis de age
#A consulta final seleciona os quartis de idade, o número total de clientes, o número total de inadimplentes, a taxa de inadimplência e o risco relativo, ordenando os resultados pelos quartis de idade.
WITH age_quartiles AS (
  SELECT
    user_id,
    age,
    NTILE(4) OVER (ORDER BY age) AS age_quartile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
--unir age_quartile com os dados originais (user_id)
data_with_quartiles AS (
  SELECT
    u.*,
    aq.age_quartile
  FROM
    `riscorelativo.projeto03.users_loans_full` u
  LEFT JOIN
    age_quartiles aq
  ON
    u.user_id = aq.user_id
),
--calcular o risco relativo por age_quartile
risk_relative AS (
  SELECT
    age_quartile,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate
  FROM
    data_with_quartiles
  GROUP BY
    age_quartile
)
SELECT
  age_quartile,
  total_customers,
  total_default,
  default_rate,
  default_rate / (SELECT AVG(default_flag) FROM data_with_quartiles) AS risk_relative
FROM
  risk_relative
ORDER BY
  age_quartile
/*essa consulta segmenta os clientes em quartis baseados no montante total do empréstimo,
calcula a taxa de inadimplência para cada quartil, e depois determina como cada taxa de inadimplência
se compara com a taxa média de inadimplência em todos os dados, fornecendo uma medida do risco relativo.*/


/*Calcular Quintis*/
-- Calcular os quintis e risco relativo para cada variável
--Consulta final para os quintis
/*essa consulta segmenta os usuários em quartis baseados no montante total do empréstimo,
calcula a taxa de inadimplência para cada quartil,
e depois determina como cada taxa de inadimplência se compara com
a taxa média de inadimplência em todos os dados, fornecendo uma medida do risco relativo.*/
WITH age_quintiles AS (
  SELECT
    user_id,
    NTILE(5) OVER (ORDER BY age) AS age_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
salary_quintiles AS (
  SELECT
    user_id,
    NTILE(5) OVER (ORDER BY last_month_salary) AS salary_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
debt_ratio_quintiles AS (
  SELECT
    user_id,
    NTILE(5) OVER (ORDER BY debt_ratio) AS debt_ratio_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
using_lines_quintiles AS (
  SELECT
    user_id,
    NTILE(5) OVER (ORDER BY using_lines_not_secured_personal_assets) AS using_lines_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
total_loan_quintiles AS (
  SELECT
    user_id,
    NTILE(5) OVER (ORDER BY total_loan) AS total_loan_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
combined_quintiles AS (
  SELECT
    u.user_id,
    u.age,
    u.last_month_salary,
    u.debt_ratio,
    u.using_lines_not_secured_personal_assets,
    u.total_loan,
    u.default_flag,
    aq.age_quintile,
    sq.salary_quintile,
    drq.debt_ratio_quintile,
    ulq.using_lines_quintile,
    tlq.total_loan_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full` u
  LEFT JOIN age_quintiles aq ON u.user_id = aq.user_id
  LEFT JOIN salary_quintiles sq ON u.user_id = sq.user_id
  LEFT JOIN debt_ratio_quintiles drq ON u.user_id = drq.user_id
  LEFT JOIN using_lines_quintiles ulq ON u.user_id = ulq.user_id
  LEFT JOIN total_loan_quintiles tlq ON u.user_id = tlq.user_id
),
age_risk_relative AS (
  SELECT
    age_quintile AS quintile,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate
  FROM
    combined_quintiles
  GROUP BY
    age_quintile
),
salary_risk_relative AS (
  SELECT
    salary_quintile AS quintile,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate
  FROM
    combined_quintiles
  GROUP BY
    salary_quintile
),
debt_ratio_risk_relative AS (
  SELECT
    debt_ratio_quintile AS quintile,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate
  FROM
    combined_quintiles
  GROUP BY
    debt_ratio_quintile
),
using_lines_risk_relative AS (
  SELECT
    using_lines_quintile AS quintile,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate
  FROM
    combined_quintiles
  GROUP BY
    using_lines_quintile
),
total_loan_risk_relative AS (
  SELECT
    total_loan_quintile AS quintile,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate
  FROM
    combined_quintiles
  GROUP BY
    total_loan_quintile
)
SELECT
  'age' AS variable,
  quintile,
  total_customers,
  total_default,
  default_rate,
  default_rate / (SELECT AVG(default_flag) FROM combined_quintiles) AS risk_relative
FROM
  age_risk_relative
UNION ALL
SELECT
  'salary' AS variable,
  quintile,
  total_customers,
  total_default,
  default_rate,
  default_rate / (SELECT AVG(default_flag) FROM combined_quintiles) AS risk_relative
FROM
  salary_risk_relative
UNION ALL
SELECT
  'debt_ratio' AS variable,
  quintile,
  total_customers,
  total_default,
  default_rate,
  default_rate / (SELECT AVG(default_flag) FROM combined_quintiles) AS risk_relative
FROM
  debt_ratio_risk_relative
UNION ALL
SELECT
  'using_lines' AS variable,
  quintile,
  total_customers,
  total_default,
  default_rate,
  default_rate / (SELECT AVG(default_flag) FROM combined_quintiles) AS risk_relative
FROM
  using_lines_risk_relative
UNION ALL
SELECT
  'total_loan' AS variable,
  quintile,
  total_customers,
  total_default,
  default_rate,
  default_rate / (SELECT AVG(default_flag) FROM combined_quintiles) AS risk_relative
FROM
  total_loan_risk_relative
ORDER BY
  variable,
  quintile;

/*Validar Hipóteses*/
--Tabela HIP1: Os mais jovens correm um risco maior de não pagamento
CREATE OR REPLACE TABLE riscorelativo.projeto03.hip1_risk_relative AS
WITH age_quintiles AS (
  SELECT
    user_id,
    age,
    NTILE(5) OVER (ORDER BY age) AS age_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
data_with_quintiles AS (
  SELECT
    u.*,
    aq.age_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full` u
  LEFT JOIN
    age_quintiles aq
  ON
    u.user_id = aq.user_id
),
risk_relative AS (
  SELECT
    age_quintile,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate,
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    AVG(age) AS avg_age
  FROM
    data_with_quintiles
  GROUP BY
    age_quintile
)
SELECT
  age_quintile,
  total_customers,
  total_default,
  default_rate,
  min_age,
  max_age,
  CONCAT(CAST(min_age AS STRING), '-', CAST(max_age AS STRING)) AS faixa_etaria, -- nova coluna faixa_etaria
  avg_age,
  default_rate / (SELECT AVG(default_flag) FROM data_with_quintiles) AS risk_relative
FROM
  risk_relative
ORDER BY
  age_quintile;


--Tabela HIP2: Pessoas com mais empréstimos ativos correm maior risco de serem maus pagadores.
--CREATE OR REPLACE TABLE riscorelativo.projeto03.hip2_risk_relative AS
WITH total_loan_quintiles AS (
  SELECT
    user_id,
    total_loan,
    NTILE(5) OVER (ORDER BY total_loan) AS total_loan_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
data_with_quintiles AS (
  SELECT
    u.*,
    aq.total_loan_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full` u
  LEFT JOIN
    total_loan_quintiles aq
  ON
    u.user_id = aq.user_id
),
risk_relative AS (
  SELECT
    total_loan_quintile,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate,
    MIN(total_loan) AS min_total_loan,
    MAX(total_loan) AS max_total_loan,
    AVG(total_loan) AS avg_total_loan,
    COUNT(*) AS number_loan  -- Contagem do número de empréstimos
  FROM
    data_with_quintiles
  GROUP BY
    total_loan_quintile
)
SELECT
  total_loan_quintile,
  total_customers,
  total_default,
  default_rate,
  --min_total_loan,
  --max_total_loan,
  avg_total_loan,
  CONCAT(CAST(min_total_loan AS STRING), '-', CAST(max_total_loan AS STRING)) AS number_loan, -- concatenação min_max
  --number_loan,  -- nova coluna adicionada
  default_rate / (SELECT AVG(default_flag) FROM data_with_quintiles) AS risk_relative
FROM
  risk_relative
ORDER BY
  total_loan_quintile;

--Tabela HIP3: Pessoas com mais empréstimos ativos correm maior risco de serem maus pagadores.
--CREATE OR REPLACE TABLE riscorelativo.projeto03.hip3_risk_relative AS
SELECT
  more_90_days_overdue,
  COUNT(*) AS total_customers,
  SUM(default_flag) AS total_default,
  AVG(default_flag) AS default_rate,
  AVG(default_flag) / (SELECT AVG(default_flag) FROM `riscorelativo.projeto03.users_loans_full`) AS risk_relative
FROM (
  SELECT
    default_flag,
    CASE
      WHEN more_90_days_overdue > 0 THEN 1
      ELSE 0
    END AS more_90_days_overdue
  FROM
    `riscorelativo.projeto03.users_loans_full`
) AS divide_90overdue
GROUP BY
  more_90_days_overdue
ORDER BY
  more_90_days_overdue;



/*tabela dos maus pagadores*/
CREATE TABLE riscorelativo.projeto03.maus_pagadores AS
SELECT 
    user_id,
    age,
    last_month_salary,
    debt_ratio,
    using_lines_not_secured_personal_assets,
    total_loan,
    more_90_days_overdue,
    default_flag,
    age_risk,
    salary_risk,
    debt_ratio_risk,
    using_lines_risk,
    total_loan_risk,
    more_90_days_risk,
    risk_score,
    CONCAT(user_id, ' - cliente mau pagador') AS user_status
FROM 
    riscorelativo.projeto03.risk_score
WHERE 
    default_flag = 1;


--JOIN e create de nova tabela para table_dashboard
CREATE OR REPLACE TABLE `riscorelativo.projeto03.table_dashboard` AS
SELECT 
user_id,
sex,
age,
number_dependents,
last_month_salary,
debt_ratio,
using_lines_not_secured_personal_assets,
total_loan,
num_real_estate,
num_other,
default_flag,more_90_days_overdue,
number_times_delayed_payment_loan_30_59_days,
number_times_delayed_payment_loan_60_89_days,
risk_score,
risk_category
FROM `riscorelativo.projeto03.table_dashboard`

--alteração de valores para melhor consulta no dashboard
CREATE OR REPLACE TABLE `riscorelativo.projeto03.table_dashboard` AS
SELECT 
    user_id,
    CASE WHEN sex = 'M' THEN 'Homem'
             WHEN sex = 'F' THEN 'Mulher'
             ELSE sex END AS sex,
    age,
    number_dependents,
    last_month_salary,
    debt_ratio,
    using_lines_not_secured_personal_assets,
    total_loan,
    num_real_estate,
    num_other,
    CASE WHEN default_flag = 1 THEN 'Sim'
        WHEN default_flag = 0 THEN 'Não'
        ELSE CAST(default_flag AS STRING) END AS default_flag,
    CASE WHEN more_90_days_overdue > 1 THEN 'Sim' ELSE 'Não' END AS more_90_days_overdue,
    CASE WHEN number_times_delayed_payment_loan_30_59_days > 1 THEN 'Sim' ELSE 'Não' END AS number_times_delayed_payment_loan_30_59_days,
    CASE WHEN number_times_delayed_payment_loan_60_89_days > 1 THEN 'Sim' ELSE 'Não' END AS number_times_delayed_payment_loan_60_89_days,
    risk_score,
    risk_category
FROM `riscorelativo.projeto03.table_dashboard`;


/*Aplicar Segmentação*/

##Calcular a pontuação de risco de cada cliente e utilizar esta pontuação para classificá-los entre bons e maus pagadores
-- construção do score
-- Segmentar quintis, risco relativo e score para cada variável
CREATE TABLE `riscorelativo.projeto03.risk_score` AS
-- Calcular quintis para a variável idade
WITH age_quintiles AS (
  SELECT
    user_id,
    NTILE(5) OVER (ORDER BY age) AS age_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
-- Calcular quintis para o salário do último mês
salary_quintiles AS (
  SELECT
    user_id,
    NTILE(5) OVER (ORDER BY last_month_salary) AS salary_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
-- Calcular quintis para a razão de dívida
debt_ratio_quintiles AS (
  SELECT
    user_id,
    NTILE(5) OVER (ORDER BY debt_ratio) AS debt_ratio_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
-- Calcular quintis para o uso de linhas de crédito não garantidas
using_lines_quintiles AS (
  SELECT
    user_id,
    NTILE(5) OVER (ORDER BY using_lines_not_secured_personal_assets) AS using_lines_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
-- Calcular quintis para a quantidade de empréstimo
total_loan_quintiles AS (
  SELECT
    user_id,
    NTILE(5) OVER (ORDER BY total_loan) AS total_loan_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
--Combinar os quintis calculados com os dados originais da tabela users_loans_full
/*através do cálculo do risco relativo foi possível selecionar os grupos de risco
pelo quintis que apresentavam mais chances de inadimplência*/
combined_quintiles AS (
  SELECT
    u.user_id,
    u.age,
    u.last_month_salary,
    u.debt_ratio,
    u.using_lines_not_secured_personal_assets,
    u.total_loan,
    u.more_90_days_overdue,
    u.default_flag,
    aq.age_quintile,
    lsq.salary_quintile,
    drq.debt_ratio_quintile,
    ulq.using_lines_quintile,
    tlq.total_loan_quintile,
    --ponto de corte pelos quintis com maiores riscos relativo
    CASE WHEN aq.age_quintile < 3 THEN 1 ELSE 0 END AS age_risk,
    CASE WHEN lsq.salary_quintile < 3 THEN 1 ELSE 0 END AS salary_risk,
    CASE WHEN drq.debt_ratio_quintile = 4 THEN 1 ELSE 0 END AS debt_ratio_risk,
    CASE WHEN ulq.using_lines_quintile = 5 THEN 1 ELSE 0 END AS using_lines_risk,
    CASE WHEN tlq.total_loan_quintile < 3 THEN 1 ELSE 0 END AS total_loan_risk,
    CASE WHEN u.more_90_days_overdue >= 1 THEN 1 ELSE 0 END AS more_90_days_risk
  FROM
    `riscorelativo.projeto03.users_loans_full` u
  LEFT JOIN age_quintiles aq ON u.user_id = aq.user_id
  LEFT JOIN salary_quintiles lsq ON u.user_id = lsq.user_id
  LEFT JOIN debt_ratio_quintiles drq ON u.user_id = drq.user_id
  LEFT JOIN using_lines_quintiles ulq ON u.user_id = ulq.user_id
  LEFT JOIN total_loan_quintiles tlq ON u.user_id = tlq.user_id
)
--Calcular a pontuação de risco 
SELECT
  user_id,
  age,
  last_month_salary,
  debt_ratio,
  using_lines_not_secured_personal_assets,
  total_loan,
  more_90_days_overdue,
  default_flag,
  age_risk,
  salary_risk,
  debt_ratio_risk,
  using_lines_risk,
  total_loan_risk,
  more_90_days_risk,
  (age_risk + salary_risk + debt_ratio_risk + using_lines_risk + total_loan_risk + more_90_days_risk) AS score
FROM
  combined_quintiles;


--Matriz de Confusão em SQL
-- Calcular a pontuação de risco e classificar os usuários com base na pontuação
WITH score AS (
  SELECT
    *,
    age_risk + salary_risk + debt_ratio_risk + using_lines_risk + total_loan_risk + more_90_days_risk AS score_default
  FROM `riscorelativo.projeto03.risk_score`
),
-- Ajustar o limiar para experimentar diferentes valores
flag_risk AS (
  SELECT
    user_id,
    CASE WHEN score_default >= 2.5 THEN 1 ELSE 0 END AS score_flag -- Ajuste do limiar para 2.5 | 3.5
  FROM score
),
-- Juntar as predições com as informações reais de default
predictions AS (
  SELECT
    s.user_id,
    s.default_flag,
    f.score_flag
  FROM score s
  JOIN flag_risk f ON s.user_id = f.user_id
),
-- Calcular a matriz de confusão
confusion_matrix AS (
  SELECT
    COUNT(*) AS total,
    SUM(CASE WHEN score_flag = 1 AND default_flag = 1 THEN 1 ELSE 0 END) AS true_positive,
    SUM(CASE WHEN score_flag = 1 AND default_flag = 0 THEN 1 ELSE 0 END) AS false_positive,
    SUM(CASE WHEN score_flag = 0 AND default_flag = 1 THEN 1 ELSE 0 END) AS false_negative,
    SUM(CASE WHEN score_flag = 0 AND default_flag = 0 THEN 1 ELSE 0 END) AS true_negative
  FROM predictions
),
-- Calcular as métricas de desempenho
metric AS (
  SELECT
    true_positive,
    false_positive,
    false_negative,
    true_negative,
    (true_positive + true_negative) / (true_positive + false_positive + false_negative + true_negative) AS accuracy,
    CASE WHEN (true_positive + false_positive) = 0 THEN 0 ELSE true_positive / (true_positive + false_positive) END AS precision,
    CASE WHEN (true_positive + false_negative) = 0 THEN 0 ELSE true_positive / (true_positive + false_negative) END AS recall,
    CASE WHEN (true_positive + false_positive + true_positive + false_negative) = 0 THEN 0
         ELSE 2 * ( (true_positive / (true_positive + false_positive)) * (true_positive / (true_positive + false_negative)) ) /
              ( (true_positive / (true_positive + false_positive)) + (true_positive / (true_positive + false_negative)) )
    END AS f1_score
  FROM confusion_matrix
)
SELECT
  true_positive,
  false_positive,
  false_negative,
  true_negative,
  accuracy,
  precision,
  recall,
  f1_score
FROM metric;