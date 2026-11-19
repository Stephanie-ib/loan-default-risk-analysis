SELECT 'removed' AS grp, COUNT(*) AS loans,
       ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct,
       ROUND(AVG(person_age), 1) AS avg_age
FROM loans WHERE person_emp_length > person_age - 14
UNION ALL
SELECT 'kept', COUNT(*), ROUND(100.0 * AVG(loan_status), 1), ROUND(AVG(person_age), 1)
FROM loans WHERE person_emp_length IS NULL OR person_emp_length <= person_age - 14;

ALTER TABLE loans RENAME TO loans_raw;
ALTER TABLE loans_clean RENAME TO loans;
DROP VIEW loans_tableau;


-- re-run query 21
WITH flagged AS (
  SELECT loan_status,
         CASE WHEN loan_percent_income >= 0.30 THEN 1 ELSE 0 END AS rule_a,
         CASE WHEN loan_grade IN ('D','E','F','G') THEN 1 ELSE 0 END AS rule_b
  FROM loans
)
SELECT 
  'Rule A' AS policy, SUM(rule_a) AS declined, SUM(rule_a * loan_status) AS defaults_avoided, 
  SUM(rule_a * (1 - loan_status)) AS good_loans_lost
FROM flagged
UNION ALL
SELECT 
  'Rule B', SUM(rule_b), SUM(rule_b * loan_status), SUM(rule_b * (1 - loan_status))
FROM flagged
UNION ALL
SELECT 
  'Rule C', SUM(MAX(rule_a, rule_b)), SUM(MAX(rule_a, rule_b) * loan_status), SUM(MAX(rule_a, rule_b) * (1 - loan_status))
FROM flagged;

-- Lending vs Defaulted Amount on Clean Table
WITH total AS (SELECT SUM(loan_amnt) AS grand_total, SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END) AS total_defaulted FROM loans)
SELECT 
    CASE WHEN loan_grade IN ('D','E','F','G') THEN 'D-G' ELSE 'A-C' END AS grade_grp,
    ROUND(100.0 * SUM(loan_amnt) / (SELECT grand_total FROM total), 1) AS pct_of_all_lending,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END) / (SELECT total_defaulted FROM total), 1) AS pct_of_total_defaulted
FROM loans GROUP BY grade_grp;
