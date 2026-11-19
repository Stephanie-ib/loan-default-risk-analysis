CREATE TABLE loans_clean AS
SELECT * FROM loans
WHERE person_emp_length IS NULL
   OR person_emp_length <= person_age - 14;
   
SELECT COUNT(*), MAX(person_age), MAX(person_emp_length) FROM loans_clean;

SELECT ROUND(100.0 * AVG(loan_status), 2) AS overall_default_rate FROM loans_clean;
-- default rate by grade
SELECT loan_grade, COUNT(*), ROUND(100.0*AVG(loan_status),1) FROM loans_clean GROUP BY loan_grade ORDER BY loan_grade;
-- LTI cliff (5-point bands)

DROP VIEW loans_tableau;
CREATE VIEW loans_tableau AS
SELECT *,
 CASE WHEN person_age < 30 THEN 'Under 30' 
			 WHEN person_age < 40 THEN '30-39' 
			 WHEN person_age < 50 THEN '40-49' 
			 WHEN person_age < 60 THEN '50-59' 
			 END AS age_band
  -- your existing age_band, income_band, lti_band_5pt, emp_status
FROM loans_clean;