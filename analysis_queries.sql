USE FinancialAnalysis;

-- =============================================
-- Query 1: Transaction Overview by Year
-- Purpose: Understand volume and amount trends
-- =============================================
SELECT 
    YEAR(transaction_date) AS year,
    COUNT(*) AS total_transactions,
    ROUND(SUM(transaction_amount), 2) AS total_amount,
    ROUND(AVG(transaction_amount), 2) AS avg_amount
FROM transactions
GROUP BY YEAR(transaction_date)
ORDER BY year;

-- =============================================
-- Query 2: Fraud vs Legitimate Analysis
-- Purpose: Overall fraud rate and amount comparison
-- =============================================
SELECT 
    is_fraud,
    COUNT(*) AS total_transactions,
    ROUND(SUM(transaction_amount), 2) AS total_amount,
    ROUND(AVG(transaction_amount), 2) AS avg_amount,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM transactions
GROUP BY is_fraud;

-- =============================================
-- Query 3: Fraud by Payment Method
-- Purpose: Identify high risk payment channels
-- =============================================
SELECT 
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM transactions
GROUP BY payment_method
ORDER BY fraud_rate DESC;

-- =============================================
-- Query 4: Fraud by Device Type
-- Purpose: Identify high risk devices
-- =============================================
SELECT 
    device_type,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM transactions
GROUP BY device_type
ORDER BY fraud_rate DESC;

-- =============================================
-- Query 5: Fraud by Customer Age Group
-- Purpose: Identify vulnerable customer segments
-- =============================================
SELECT 
    CASE 
        WHEN customer_age < 25 THEN 'Under 25'
        WHEN customer_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN customer_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN customer_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and above'
    END AS age_group,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM transactions
GROUP BY 
    CASE 
        WHEN customer_age < 25 THEN 'Under 25'
        WHEN customer_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN customer_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN customer_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and above'
    END
ORDER BY fraud_rate DESC;

-- =============================================
-- Query 6: Fraud by Merchant Category
-- Purpose: Identify high risk merchant types
-- =============================================
SELECT 
    merchant_category,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_rate,
    ROUND(SUM(transaction_amount), 2) AS total_amount
FROM transactions
GROUP BY merchant_category
ORDER BY fraud_rate DESC;

-- =============================================
-- Query 7: Night vs Day Fraud Comparison
-- Purpose: Identify time based fraud patterns
-- =============================================
SELECT 
    CASE WHEN is_night_transaction = 1 THEN 'Night (10PM-6AM)' 
         ELSE 'Day (6AM-10PM)' END AS time_period,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM transactions
GROUP BY is_night_transaction
ORDER BY fraud_rate DESC;