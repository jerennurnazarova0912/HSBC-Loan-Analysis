-- CREATE TABLE hsbc_loan_analysis (
--   ... your existing schema ...
-- );

-- Baseline: flat threshold, no grouping (naive approach)
SELECT 
    customer_id,
    income,
    CASE WHEN income > (SELECT PERCENTILE_CONT(0.5) 
                         WITHIN GROUP (ORDER BY income) 
                         FROM personal_loan_data) 
         THEN 1 ELSE 0 END AS baseline_predicted_approval
FROM personal_loan_data;

-- Improved: risk-tier ranking using window function, grouped by education
SELECT 
    customer_id,
    income,
    education,
    PERCENT_RANK() OVER (PARTITION BY education ORDER BY income) AS income_percentile_in_group,
    CASE WHEN PERCENT_RANK() OVER (PARTITION BY education ORDER BY income) > 0.75 
         THEN 1 ELSE 0 END AS window_predicted_approval
FROM personal_loan_data;
