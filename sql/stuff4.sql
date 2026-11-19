-- Check the old table
SELECT COUNT(*), MAX(person_age), MAX(person_emp_length) FROM loans;
-- Check the new table
SELECT COUNT(*), MAX(person_age), MAX(person_emp_length) FROM loans_clean;
-- Find the impossible rows in the old table
SELECT * FROM loans WHERE person_age > 100 OR person_emp_length > 60;
DROP TABLE loans;
ALTER TABLE loans_final RENAME TO loans;

SELECT COUNT(*), MAX(person_age), MAX(person_emp_length) FROM loans;
-- Should return 32564, 94, 123
SELECT * FROM loans WHERE person_age > 100 OR person_emp_length > 60;
-- Should return 0 rows

/*
Step 5: Check the Worst Employment Rows
*/
SELECT person_age, person_emp_length FROM loans 
WHERE person_emp_length > person_age - 12 
ORDER BY person_emp_length DESC LIMIT 20;

SELECT name, type FROM sqlite_master;
DROP TABLE loan_clean;

SELECT person_age - person_emp_length AS start_age, COUNT(*) AS loans
FROM loans
WHERE person_emp_length IS NOT NULL
GROUP BY start_age
ORDER BY start_age
LIMIT 25;

SELECT person_age - person_emp_length AS start_age, COUNT(*) AS loans
FROM loans
WHERE person_emp_length IS NOT NULL
GROUP BY start_age
ORDER BY start_age;

SELECT COUNT(*) AS rows_to_remove
FROM loans
WHERE person_emp_length IS NOT NULL
  AND person_emp_length > person_age - 14;
  
  
SELECT COUNT(*) AS rows_to_null
FROM loans
WHERE person_emp_length IS NOT NULL
  AND person_emp_length > person_age - 14;
  
  
SELECT person_age, person_emp_length, loan_status, loan_grade, loan_percent_income
FROM loans
WHERE person_emp_length IS NOT NULL
  AND person_emp_length > person_age - 14
ORDER BY person_emp_length DESC
LIMIT 20;
 
 SELECT COUNT(*) AS suspicious FROM loans WHERE person_emp_length > person_age - 14;
 
  SELECT COUNT(*) AS suspicious FROM loans WHERE person_emp_length > person_age - 12;
  
SELECT COUNT(*), MAX(person_age), MAX(person_emp_length) FROM loans;