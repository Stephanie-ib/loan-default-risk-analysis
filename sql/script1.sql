UPDATE loans SET loan_int_rate = NULL WHERE loan_int_rate = '';
UPDATE loans SET person_emp_length = NULL WHERE person_emp_length = '';
SELECT COUNT(*) AS total_loans FROM loans;
SELECT * FROM loans LIMIT 10;
SELECT COUNT(*) AS missing_rates FROM loans WHERE loan_int_rate IS NULL;
SELECT COUNT(*) AS total_loans,
       SUM(loan_status) AS defaults,
       ROUND(100.0 * AVG(loan_status), 2) AS default_rate_pct
FROM loans;

SELECT loan_grade,
       COUNT(*) AS loans,
       ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct,
       ROUND(AVG(loan_int_rate), 2) AS avg_rate
FROM loans
GROUP BY loan_grade
ORDER BY loan_grade;

-- Query 6: By Home Ownership (Sorted Highest to Lowest)
SELECT person_home_ownership,
       COUNT(*) AS loans,
       ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY person_home_ownership
ORDER BY default_rate_pct DESC;


-- Query 7: By Loan Intent
SELECT loan_intent,
       COUNT(*) AS loans,
       ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY loan_intent
ORDER BY default_rate_pct DESC;

-- Query 8: By Previous Default on File
SELECT cb_person_default_on_file,
       COUNT(*) AS loans,
       ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY cb_person_default_on_file
ORDER BY default_rate_pct DESC;



-- Query 9: Renters in High-Risk Grades (D, E, F, G)
SELECT loan_grade,
       COUNT(*) AS loans,
       ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
WHERE person_home_ownership = 'RENT' 
  AND loan_grade IN ('D', 'E', 'F', 'G')
GROUP BY loan_grade
ORDER BY loan_grade;

-- Query 10: Age bands 
SELECT
  CASE
    WHEN person_age < 25 THEN '20-24'
    WHEN person_age < 30 THEN '25-29'
    WHEN person_age < 40 THEN '30-39'
    WHEN person_age < 60 THEN '40-59'
    ELSE '60+'
  END AS age_band,
  COUNT(*) AS loans,
  ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY age_band
ORDER BY MIN(person_age);

-- Query 11: Missing employment length
SELECT
  CASE WHEN person_emp_length IS NULL THEN 'Unknown' ELSE 'Known' END AS emp_status,
  COUNT(*) AS loans,
  ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY emp_status;


-- Query 12: Using HAVING
SELECT loan_intent, loan_grade,
       COUNT(*) AS loans,
       ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY loan_intent, loan_grade
HAVING COUNT(*) >= 200
ORDER BY default_rate_pct DESC;


-- Query 13: Find the exact LTI cliff
SELECT
    CASE 
        WHEN loan_percent_income < 0.05 THEN 'Under 5%'
        WHEN loan_percent_income < 0.10 THEN '5-10%'
        WHEN loan_percent_income < 0.15 THEN '10-15%'
        WHEN loan_percent_income < 0.20 THEN '15-20%'
        WHEN loan_percent_income < 0.25 THEN '20-25%'
        WHEN loan_percent_income < 0.30 THEN '25-30%'
        WHEN loan_percent_income < 0.35 THEN '30-35%'
        WHEN loan_percent_income < 0.40 THEN '35-40%'
        WHEN loan_percent_income < 0.45 THEN '40-45%'
        WHEN loan_percent_income < 0.50 THEN '45-50%'
        ELSE '50%+' 
    END AS lti_band,
    COUNT(*) AS loans,
    ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY lti_band
ORDER BY MIN(loan_percent_income);

-- Query 14: LTI within a Grade (Confounding Test)
SELECT 
    loan_grade,
    CASE 
        WHEN loan_percent_income < 0.30 THEN 'Under 30%'
        ELSE '30% and above'
    END AS lti_category,
    COUNT(*) AS loans,
    ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY loan_grade, lti_category
HAVING COUNT(*) >= 50
ORDER BY loan_grade, lti_category;


-- Query 15: Renting within a Grade
SELECT 
    loan_grade,
    CASE 
        WHEN person_home_ownership = 'RENT' THEN 'Renter'
        ELSE 'Non-renter'
    END AS home_status,
    COUNT(*) AS loans,
    ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY loan_grade, home_status
ORDER BY loan_grade, home_status;