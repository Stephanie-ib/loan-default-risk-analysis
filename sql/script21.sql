/*
Query 21: Policy Simulation (Rules A, B, C)
Rule A: Decline LTI >= 30%
*/
WITH flagged AS (
  SELECT loan_status,
         CASE WHEN loan_percent_income >= 0.30 THEN 1 ELSE 0 END AS rule_a
  FROM loans
)
SELECT 'Rule A: LTI >= 30%' AS policy,
       SUM(rule_a) AS declined,
       SUM(rule_a * loan_status) AS defaults_avoided,
       SUM(rule_a * (1 - loan_status)) AS good_loans_lost,
       ROUND(100.0 * SUM((1 - rule_a) * loan_status) / SUM(1 - rule_a), 1) AS new_default_rate_pct,
       ROUND(1.0 * SUM(rule_a * loan_status) / SUM(rule_a * (1 - loan_status)), 2) AS efficiency_ratio
FROM flagged;

-- Rule B: Decline Grades D-G
WITH flagged AS (
  SELECT loan_status,
         CASE WHEN loan_grade IN ('D','E','F','G') THEN 1 ELSE 0 END AS rule_b
  FROM loans
)
SELECT 'Rule B: Decline D-G' AS policy,
       SUM(rule_b) AS declined,
       SUM(rule_b * loan_status) AS defaults_avoided,
       SUM(rule_b * (1 - loan_status)) AS good_loans_lost,
       ROUND(100.0 * SUM((1 - rule_b) * loan_status) / SUM(1 - rule_b), 1) AS new_default_rate_pct,
       ROUND(1.0 * SUM(rule_b * loan_status) / SUM(rule_b * (1 - loan_status)), 2) AS efficiency_ratio
FROM flagged;


--- Rule C: Both Rules (Decline if LTI >= 30% OR Grade D-G)
WITH flagged AS (
  SELECT loan_status,
         CASE WHEN loan_percent_income >= 0.30 THEN 1 ELSE 0 END AS rule_a,
         CASE WHEN loan_grade IN ('D','E','F','G') THEN 1 ELSE 0 END AS rule_b
  FROM loans
)
SELECT 'Rule C: Both Rules' AS policy,
       SUM(MAX(rule_a, rule_b)) AS declined,
       SUM(MAX(rule_a, rule_b) * loan_status) AS defaults_avoided,
       SUM(MAX(rule_a, rule_b) * (1 - loan_status)) AS good_loans_lost,
       ROUND(100.0 * SUM((1 - MAX(rule_a, rule_b)) * loan_status) / SUM(1 - MAX(rule_a, rule_b)), 1) AS new_default_rate_pct,
       ROUND(1.0 * SUM(MAX(rule_a, rule_b) * loan_status) / SUM(MAX(rule_a, rule_b) * (1 - loan_status)), 2) AS efficiency_ratio
FROM flagged;