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


--Para a variável more_90_days_overdue não foi utilizado quintis.
--Os clientes com atraso superior a 90 dias (valor >= 1) são considerados de alto risco.
/*WITH quartis_90overdue AS (
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
  */