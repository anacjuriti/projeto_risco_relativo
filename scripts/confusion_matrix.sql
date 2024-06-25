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
