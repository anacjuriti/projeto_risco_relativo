##Calcular a pontuação de risco de cada cliente e utilizar esta pontuação para classificá-los entre bons e maus pagadores
-- construção do score
-- Calcular quintis e risco relativo para cada variável

--CREATE OR REPLACE TABLE `riscorelativo.projeto03.risk_score` AS
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
    u.more_90_days_overdue,
    u.default_flag,
    aq.age_quintile,
    lsq.salary_quintile,
    drq.debt_ratio_quintile,
    ulq.using_lines_quintile,
    tlq.total_loan_quintile,
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

