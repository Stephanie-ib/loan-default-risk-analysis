-- Query 22: Income vs. LTI
SELECT 
    CASE 
        WHEN person_income < 30000 THEN 'Under 30k'
        WHEN person_income < 60000 THEN '30k-60k'
        WHEN person_income < 100000 THEN '60k-100k'
        ELSE '100k+'
    END AS income_band,
    CASE 
        WHEN loan_percent_income < 0.30 THEN 'Under 30% LTI'
        ELSE '30%+ LTI'
    END AS lti_category,
    COUNT(*) AS loans,
    ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY income_band, lti_category
ORDER BY MIN(person_income), lti_category;


-- Query 23: The Age Puzzle
-- First, rerun the average grade correctly using ASCII math
SELECT 
    CASE WHEN person_age >= 40 THEN '40+' ELSE 'Under 40' END AS age_group,
    COUNT(*) AS loans,
    ROUND(AVG(unicode(loan_grade) - 64), 1) AS avg_grade_num,
    ROUND(100.0 * SUM(CASE WHEN person_home_ownership = 'RENT' THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_renters,
    ROUND(AVG(loan_percent_income), 2) AS avg_lti,
    ROUND(100.0 * SUM(CASE WHEN person_emp_length IS NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_unknown_emp,
    ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY age_group;

-- Second, test whether age is the real driver by grouping by age AND LTI
SELECT 
    CASE WHEN person_age >= 40 THEN '40+' ELSE 'Under 40' END AS age_group,
    CASE WHEN loan_percent_income < 0.30 THEN 'Under 30% LTI' ELSE '30%+ LTI' END AS lti_category,
    COUNT(*) AS loans,
    ROUND(100.0 * AVG(loan_status), 1) AS default_rate_pct
FROM loans
GROUP BY age_group, lti_category
ORDER BY age_group, lti_category;