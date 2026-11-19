# Consumer Loan Default Risk Analysis

## Summary
An end-to-end data analysis of 29,467 consumer loans to identify the primary drivers of default risk, culminating in a published Tableau dashboard and actionable policy recommendations.

## Business Problem
A consumer lending institution needs to understand the characteristics that drive loan defaults. The goal of this analysis is to isolate the highest-risk borrower profiles (such as high loan-to-income ratios and low credit grades) and recommend specific approval and pricing policies to minimize defaults while preserving good lending volume.

## Dataset
- **Source:** Kaggle Credit Risk Dataset (Laotse)
- **Size:** 32,564 raw rows (reduced to 29,467 clean rows)
- **Limitations:** Simulated data, no time/repayment terms, approved loans only, currency not stated.

## Tools & Approach
- **Excel:** Initial data profiling, handling missing values, and flagging impossible employment lengths.
- **SQLite (DB Browser):** Database creation, advanced data cleaning (removing 3,097 biologically implausible rows), and complex analytical queries (CTEs, Window Functions, Policy Simulations).
- **Tableau Public:** Building an interactive dashboard to visualize the "LTI Cliff," the "Grade A Trap," and homeownership risk.

## Key Findings
1. **The 30% LTI Cliff:** Default risk jumps from ~25% to ~60% once a borrower's Loan-to-Income (LTI) ratio exceeds 30%.
2. **The Grade A Trap:** A "safe" Grade A loan with an LTI > 30% defaults at roughly **[insert %]**—as risky as a Grade D loan.
3. **D-G Concentration:** Grades D through G make up **[insert %]** of lending volume but account for **[insert %]** of defaulted capital.
4. **Renter Premium:** Renters default at ~31%, roughly 4x the rate of outright homeowners (~8%). Within D-G, renters default at **[insert %]**.

## Recommendations
- **LTI Cap:** Implement a hard decline for LTI >= 30%. *Impact: Avoids 2,686 defaults, loses 1,317 good loans.*
- **Grade Restrictions:** Withdraw unsecured lending for Grades D-G (required breakeven rates would exceed 92%) and apply modest repricing (+1 to +3 points) to Grades B and C.
- **Previous Defaults:** Do not auto-decline borrowers with previous defaults (efficiency ratio is only **[insert ratio]**); instead, use it as a limit or pricing input.

## Dashboard
- **[View the Interactive Tableau Dashboard Here](https://public.tableau.com/app/profile/stephanie.ibrahim/viz/CreditRiskLoanDefaultAnalysis/Dashboard2?publish=yes)**
- ![Dashboard Screenshot](tableau/dashboard.png)

## Repository Structure
- `data/` : Cleaned CSV exports
- `excel/` : Data cleaning workbook
- `sql/` : Database setup and analysis scripts
- `tableau/` : Dashboard screenshots
- `docs/` : Data dictionary and cleaning log

## About Me
Stephanie Ibrahim - [https://www.linkedin.com/in/stephanie-ibrahim-715a4b292/]