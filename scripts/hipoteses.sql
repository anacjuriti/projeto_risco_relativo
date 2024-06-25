/*Hipótese:
Os mais jovens correm um risco maior de não pagamento.
Pessoas com mais empréstimos ativos correm maior risco de serem maus pagadores.
Pessoas que atrasaram seus pagamentos por mais de 90 dias correm maior risco de serem maus pagadores.
💡 Após validar as hipóteses de acordo com o resultado do cálculo do risco relativo, construa uma tabela com os grupos de cada variável que apresenta maior risco de ser um mau pagador.*/


--HIP: Os mais jovens correm um risco maior de não pagamento. -> CONFIRMADA
--Os Q1 e Q2 tem o maior risco de inadimplência, sendo respectivamente 1.76 e 1.35 vezes mais provável que os clientes deste grupo sejam inadimplentes em comparação com a média geral
--Logo, conforme o risco relativo, é possivel afirmar que pessoas mais jovem correm um risco maior de não pagamento.
WITH age_quintiles AS (
  SELECT
    user_id,
    age,
    NTILE(5) OVER (ORDER BY age) AS age_quintile
  FROM
    `riscorelativo.projeto03.users_loans_full`
),
data_with_quintiles AS (  --combinando os dados com base em user_id para incluir o quintil de idade em cada linha
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
risk_relative AS ( --cálculo estatísticos para cada quintil de idade
  SELECT
    age_quintile,
    COUNT(*) AS total_customers, --número total de clientes
    SUM(default_flag) AS total_default, --soma das flags de inadimplência
    AVG(default_flag) AS default_rate, --taxa média de inadimplência
    MIN(age) AS min_age, --idade mínima
    MAX(age) AS max_age, --idade máxima
    AVG(age) AS avg_age  --idade média
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
  avg_age,
  default_rate / (SELECT AVG(default_flag) FROM data_with_quintiles) AS risk_relative --cálculo do risk_relative dividindo a default_rate de cada quintil pela taxa média de inadimplência
FROM
  risk_relative
ORDER BY
  age_quintile;


--HIP: Pessoas com mais empréstimos ativos correm maior risco de serem maus pagadores. -> REFUTADA
--O risco relativo dos Q1 (1-4 loans)e Q2 (4-7 loans) são muitos altos, respectivamente 1.61 e 1.29 vezes de chances de se tornar um grupo inadimplente, enquanto que grupos com mais de 7 empréstimos apresenta risco menor.
--Hipótese refutada, pois conforme o risco relativo, grupos com mais empréstimos tende a serem melhores pagadores 
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
    AVG(total_loan) AS avg_total_loan
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
  min_total_loan,
  max_total_loan,
  avg_total_loan,
  default_rate / (SELECT AVG(default_flag) FROM data_with_quintiles) AS risk_relative
FROM
  risk_relative
ORDER BY
  total_loan_quintile;

--HIP: Pessoas que atrasaram seus pagamentos por mais de 90 dias correm maior risco de serem maus pagadores. -> CONFIRMADA
--Conforme o risco relativo da variável more_90_days_overdue, existe 18 vezes chances de que pessoas que atrasam pagamento por mais de 90 dias serem maus pagadores
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
/*SELECT
  more_90_days_overdue,
  COUNT(*) AS total_customers,
  SUM(default_flag) AS total_default,
  AVG(default_flag) AS default_rate,
  AVG(default_flag) / (SELECT AVG(default_flag) FROM `riscorelativo.projeto03.users_loans_full`) AS risk_relative
FROM
  `riscorelativo.projeto03.users_loans_full`
GROUP BY
  more_90_days_overdue
ORDER BY
  more_90_days_overdue;
*/


--number_times_delayed_payment_loan_30_59_days
SELECT
  number_times_delayed_payment_loan_30_59_days,
  COUNT(*) AS total_customers,
  SUM(default_flag) AS total_default,
  AVG(default_flag) AS default_rate,
  AVG(default_flag) / (SELECT AVG(default_flag) FROM `riscorelativo.projeto03.users_loans_full`) AS risk_relative
FROM (
  SELECT
    default_flag,
    CASE
      WHEN number_times_delayed_payment_loan_30_59_days > 0 THEN 1
      ELSE 0
    END AS number_times_delayed_payment_loan_30_59_days
  FROM
    `riscorelativo.projeto03.users_loans_full`
) AS divide_90overdue
GROUP BY
  number_times_delayed_payment_loan_30_59_days
ORDER BY
  number_times_delayed_payment_loan_30_59_days;


--number_times_delayed_payment_loan_60_89_days
SELECT
  number_times_delayed_payment_loan_60_89_days,
  COUNT(*) AS total_customers,
  SUM(default_flag) AS total_default,
  AVG(default_flag) AS default_rate,
  AVG(default_flag) / (SELECT AVG(default_flag) FROM `riscorelativo.projeto03.users_loans_full`) AS risk_relative
FROM (
  SELECT
    default_flag,
    CASE
      WHEN number_times_delayed_payment_loan_60_89_days > 0 THEN 1
      ELSE 0
    END AS number_times_delayed_payment_loan_60_89_days
  FROM
    `riscorelativo.projeto03.users_loans_full`
) AS divide_90overdue
GROUP BY
  number_times_delayed_payment_loan_60_89_days
ORDER BY
  number_times_delayed_payment_loan_60_89_days;