/*
Query 16: Your own question
Let's look at income. Does someone with a higher income default less?
*/
SELECT 
    CASE 
        WHEN person_income < 30000 THEN 'Under 30k'
        WHEN person_income < 60000 THEN '30k-60k'
        WHEN person_income < 100000 THEN '60k-100k'
        ELSE '100k+'
    END AS income_band,
    COUNT(*) AS loans,
    ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY income_band
ORDER BY MIN(person_income);

-- Query 17: Validate the cleaning
SELECT MAX(person_age) AS max_age, MAX(person_emp_length) AS max_emp FROM loans;
SELECT COUNT(*) AS suspicious FROM loans WHERE person_emp_length > person_age - 16;


-- Query 18: CTE and a risk index (worked example)
WITH overall AS (
  SELECT AVG(loan_status) AS overall_rate FROM loans
),
by_grade AS (
  SELECT loan_grade, COUNT(*) AS loans,
         AVG(loan_status) AS grade_rate
  FROM loans
  GROUP BY loan_grade
)
SELECT g.loan_grade, g.loans,
       ROUND(100.0 * g.grade_rate, 1) AS default_rate_pct,
       ROUND(g.grade_rate / o.overall_rate, 2) AS risk_index
FROM by_grade g, overall o
ORDER BY g.loan_grade;

-- Query 19: Window function (worked example)
WITH seg AS (
  SELECT loan_grade, loan_intent, COUNT(*) AS loans,
         AVG(loan_status) AS rate
  FROM loans
  GROUP BY loan_grade, loan_intent
  HAVING COUNT(*) >= 50
)
SELECT loan_grade, loan_intent, loans,
       ROUND(100.0 * rate, 1) AS default_rate_pct,
       RANK() OVER (PARTITION BY loan_grade ORDER BY rate DESC) AS risk_rank
FROM seg
ORDER BY loan_grade, risk_rank;

-- Query 20: Where is the money?
WITH total AS (
  SELECT SUM(loan_amnt) AS grand_total,
         SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END) AS total_defaulted
  FROM loans
)
SELECT 
    loan_grade,
    SUM(loan_amnt) AS total_lent,
    ROUND(100.0 * SUM(loan_amnt) / (SELECT grand_total FROM total), 1) AS pct_of_all_lending,
    SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END) AS defaulted_amount,
    ROUND(100.0 * SUM(CASE WHEN loan_status = 1 THEN loan_amnt ELSE 0 END) / (SELECT total_defaulted FROM total), 1) AS pct_of_total_defaulted
FROM loans
GROUP BY loan_grade
ORDER BY loan_grade;
