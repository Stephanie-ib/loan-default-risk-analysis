DROP VIEW IF EXISTS loans_tableau;

CREATE VIEW loans_tableau AS
SELECT
  loan_grade,
  loan_intent,
  person_home_ownership,
  cb_person_default_on_file,
  loan_status,
  loan_amnt,
  loan_int_rate,
  loan_percent_income,
  person_income,
  person_age,
  person_emp_length,
  CASE
    WHEN person_age < 25 THEN '20-24'
    WHEN person_age < 30 THEN '25-29'
    WHEN person_age < 40 THEN '30-39'
    WHEN person_age < 60 THEN '40-59'
    ELSE '60+'
  END AS age_band,
  CASE
    WHEN person_income < 30000 THEN 'Under 30k'
    WHEN person_income < 60000 THEN '30k-60k'
    WHEN person_income < 100000 THEN '60k-100k'
    ELSE '100k+'
  END AS income_band,
  CASE
    WHEN loan_percent_income < 0.10 THEN 'Under 10%'
    WHEN loan_percent_income < 0.15 THEN '10-15%'
    WHEN loan_percent_income < 0.20 THEN '15-20%'
    WHEN loan_percent_income < 0.25 THEN '20-25%'
    WHEN loan_percent_income < 0.30 THEN '25-30%'
    WHEN loan_percent_income < 0.35 THEN '30-35%'
    ELSE '35%+'
  END AS lti_band_5pt,
  CASE WHEN person_emp_length IS NULL THEN 'Unknown' ELSE 'Known' END AS emp_status
FROM loans_clean;


SELECT COUNT(*) FROM loans_tableau;                          -- expect 29,467
SELECT age_band, COUNT(*) FROM loans_tableau GROUP BY age_band;   -- no NULL row
SELECT lti_band_5pt, COUNT(*) FROM loans_tableau GROUP BY lti_band_5pt;
SELECT MAX(person_age), MAX(person_emp_length) FROM loans_tableau; -- 94, 11

SELECT
  CASE WHEN person_age >= 40 THEN '40+' ELSE 'Under 40' END AS age_group,
  CASE WHEN loan_percent_income < 0.30 THEN 'Under 30% LTI' ELSE '30%+ LTI' END AS lti_category,
  COUNT(*) AS loans,
  ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans_clean
GROUP BY age_group, lti_category
ORDER BY age_group, lti_category;

SELECT * FROM loans_tableau;