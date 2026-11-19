CREATE VIEW loans_tableau AS
SELECT
  loan_grade, loan_intent, person_home_ownership,
  cb_person_default_on_file, loan_status, loan_amnt, loan_int_rate,
  loan_percent_income, person_income, person_age,  person_emp_length,
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
    WHEN loan_percent_income < 0.1 THEN 'Under 10%'
    WHEN loan_percent_income < 0.2 THEN '10-20%'
    WHEN loan_percent_income < 0.3 THEN '20-30%'
    WHEN loan_percent_income < 0.4 THEN '30-40%'
    ELSE '40%+'
  END AS lti_band,
  CASE WHEN person_emp_length IS NULL THEN 'Unknown' ELSE 'Known' END AS emp_status
FROM loans_final;

SELECT * FROM loans_tableau;