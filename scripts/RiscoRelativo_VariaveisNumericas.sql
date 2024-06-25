//Risco Relativo Em Variáveis Numéricas

--riscorelativo_90overdue
WITH quartis_90overdue AS (
  SELECT
    default_flag,
    CASE
      WHEN more_90_days_overdue > 0 THEN 1
      ELSE 0
    END AS more_90_days_overdue
  FROM
    `riscorelativo.projeto03.users_loans_full`
)
, aggregated_data AS (
  SELECT
    more_90_days_overdue,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate
  FROM
    quartis_90overdue
  GROUP BY
    more_90_days_overdue
)
SELECT
  more_90_days_overdue,
  total_customers,
  total_default,
  default_rate,
  default_rate / (SELECT AVG(default_flag) FROM quartis_90overdue) AS risk_relative
FROM
  aggregated_data
ORDER BY
  more_90_days_overdue;
  
  

--riscorelativo_endividamento
WITH debt_ratio_quintiles AS (
  SELECT
    user_id,
    debt_ratio,
    NTILE(5) OVER (ORDER BY debt_ratio) AS debt_ratio_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
data_with_quintiles AS (
  SELECT
    u.*,
    aq.debt_ratio_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full` u
  LEFT JOIN
    debt_ratio_quintiles aq
  ON
    u.user_id = aq.user_id
),
risk_relative AS (
  SELECT
    debt_ratio_quintile,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate
  FROM
    data_with_quintiles
  GROUP BY
    debt_ratio_quintile
)
SELECT
  debt_ratio_quintile,
  total_customers,
  total_default,
  default_rate,
  default_rate / (SELECT AVG(default_flag) FROM data_with_quintiles) AS risk_relative
FROM
  risk_relative
ORDER BY
  debt_ratio_quintile
  

--riscorelativo_idade
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
    AVG(default_flag) AS default_rate
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
  default_rate / (SELECT AVG(default_flag) FROM data_with_quintiles) AS risk_relative
FROM
  risk_relative
ORDER BY
  age_quintile
  
--riscorelativo_limiteusado
WITH using_lines_quintiles AS (
  SELECT
    user_id,
    using_lines_not_secured_personal_assets,
    NTILE(5) OVER (ORDER BY using_lines_not_secured_personal_assets) AS using_lines_not_secured_personal_assets_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
data_with_quintiles AS (
  SELECT
    u.*,
    aq.using_lines_not_secured_personal_assets_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full` u
  LEFT JOIN
    using_lines_quintiles aq
  ON
    u.user_id = aq.user_id
),
risk_relative AS (
  SELECT
    using_lines_not_secured_personal_assets_quintile,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate
  FROM
    data_with_quintiles
  GROUP BY
    using_lines_not_secured_personal_assets_quintile
)
SELECT
  using_lines_not_secured_personal_assets_quintile,
  total_customers,
  total_default,
  default_rate,
  default_rate / (SELECT AVG(default_flag) FROM data_with_quintiles) AS risk_relative
FROM
  risk_relative
ORDER BY
  using_lines_not_secured_personal_assets_quintile
  
--riscorelativo_salario
WITH salary_quintiles AS (
  SELECT
    user_id,
    last_month_salary,
    NTILE(5) OVER (ORDER BY last_month_salary) AS last_month_salary_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
data_with_quintiles AS (
  SELECT
    u.*,
    aq.last_month_salary_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full` u
  LEFT JOIN
    salary_quintiles aq
  ON
    u.user_id = aq.user_id
),
risk_relative AS (
  SELECT
    last_month_salary_quintile,
    COUNT(*) AS total_customers,
    SUM(default_flag) AS total_default,
    AVG(default_flag) AS default_rate
  FROM
    data_with_quintiles
  GROUP BY
    last_month_salary_quintile
)
SELECT
  last_month_salary_quintile,
  total_customers,
  total_default,
  default_rate,
  default_rate / (SELECT AVG(default_flag) FROM data_with_quintiles) AS risk_relative
FROM
  risk_relative
ORDER BY
  last_month_salary_quintile
  
--riscorelativo_total_loan
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
    AVG(default_flag) AS default_rate
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
  default_rate / (SELECT AVG(default_flag) FROM data_with_quintiles) AS risk_relative
FROM
  risk_relative
ORDER BY
  total_loan_quintile
  
  
--risk_category
--CREATE TABLE riscorelativo.projeto03.risk_score AS
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
    CASE
        WHEN risk_score BETWEEN 0 AND 1 THEN 'Menor Risco de Inadimplência'
        WHEN risk_score BETWEEN 2 AND 3 THEN 'Risco Moderado a Baixo de Inadimplência'
        ELSE 'Maior Risco de Inadimplência'
    END AS risk_category
FROM
    `riscorelativo.projeto03.risk_score`;


--Percentis do risk_score
--risk_score 0-1 => 'Menor Risco de Inadimplência'
--risk_score 2-3 => 'Risco Moderado a Baixo de Inadimplência'
--risk_score +3 => 'Maior Risco de Inadimplência'
 /* WITH percentis AS (
  SELECT
    NTILE(3) OVER (ORDER BY risk_score) AS percentile,
    risk_score
  FROM `riscorelativo.projeto03.risk_score`
)
SELECT
  percentile,
  MIN(risk_score) AS min_score,
  MAX(risk_score) AS max_score,
  COALESCE(COUNT(*), 0) AS count
FROM
  percentis
GROUP BY
  percentile
ORDER BY
  percentile;*/


