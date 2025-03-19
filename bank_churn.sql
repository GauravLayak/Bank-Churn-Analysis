DROP TABLE IF EXISTS bank_churn;
CREATE TABLE bank_churn (
CustomerId	INT,
Surname	TEXT,
CreditScore	INT,
Geography VARCHAR(100),
Gender VARCHAR(100),
Age	INT,
Tenure INT,
Balance	FLOAT,
NumOfProducts INT,	
HasCrCard VARCHAR(10),
IsActiveMember VARCHAR(10),
EstimatedSalary	FLOAT,
Exited VARCHAR(10)
);

SELECT * FROM bank_churn;
SELECT COUNT(*) FROM bank_churn;

-- KPI requirements --
-- Total Customers
SELECT COUNT(*) AS total_cust FROM bank_churn;

-- Total Active customers
SELECT COUNT(isactivemember) AS total_active_cust FROM bank_churn
WHERE isactivemember = 'Yes';

-- Total Exited Customers
SELECT COUNT(exited) AS total_cust_exited FROM bank_churn
WHERE exited = 'Yes';

-- Total Customers Exited by each Country
SELECT 
	Geography,
	COUNT(exited) AS total
FROM bank_churn
WHERE exited = 'Yes'
GROUP BY Geography
ORDER BY total DESC;

-- Average Tenure
SELECT ROUND(AVG(tenure)::numeric, 2) AS Avg_tenure
FROM bank_churn;

-- Total Number of Customers having Credit Card
SELECT COUNT(hascrcard) AS total
FROM bank_churn
WHERE hascrcard = 'Yes';

-- Average Estimated Salary
SELECT ROUND(AVG(estimatedsalary)::numeric,2) AS avg_estimated_salary
FROM bank_churn;

-- See if account balance influences churn
SELECT exited, ROUND(AVG(balance)::numeric,2) AS avg_balance
FROM bank_churn
GROUP BY exited;

-- Total Active Female Customers
SELECT COUNT(*) AS total_female_cust
FROM bank_churn
WHERE Gender = 'Female' AND isactivemember = 'Yes';

-- Total Active Male Customers
SELECT COUNT(*) AS total_male_cust
FROM bank_churn
WHERE Gender = 'Male' AND isactivemember = 'Yes';

-- Average Credit score
SELECT ROUND(AVG(creditscore)::numeric,0) AS avg_creditscore
FROM bank_churn;

-- Find customers who left the bank within the first few years
SELECT customerid, surname, tenure, balance
FROM bank_churn
WHERE exited = 'Yes' 
AND tenure <= 2
ORDER BY tenure ASC;

-- Check if low credit scores lead to higher churn.
SELECT 
    CASE 
        WHEN creditscore < 400 THEN 'Very Low (0-399)'
        WHEN creditscore BETWEEN 400 AND 599 THEN 'Low (400-599)'
        WHEN creditscore BETWEEN 600 AND 799 THEN 'Medium (600-799)'
        ELSE 'High (800-1000)'
    END AS credit_score_category,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN exited = 'Yes' THEN 1 END) AS churned_customers,
    ROUND(COUNT(CASE WHEN exited = 'Yes' THEN 1 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY credit_score_category
ORDER BY churn_rate DESC;

-- Find customers with low balance & low credit scores who are likely to churn.
SELECT customerid, surname, balance, creditscore, tenure
FROM bank_churn
WHERE balance < 5000 
AND creditscore < 500
AND exited = 'No' -- They haven't churned yet but are at risk
ORDER BY creditscore ASC;

-- Identify customers with high balances who still churned (important for retention strategy).
SELECT customerid, surname, balance, creditscore, tenure
FROM bank_churn
WHERE exited = 'Yes' 
AND balance > 100000
ORDER BY balance DESC;

-- Group customers by age brackets to see which age group churns the most.
SELECT 
    CASE 
        WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 40 THEN '25-40'
        WHEN age BETWEEN 41 AND 60 THEN '41-60'
        ELSE 'Above 60'
    END AS age_group,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN exited = 'Yes' THEN 1 END) AS churned_customers,
    ROUND(COUNT(CASE WHEN exited = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM bank_churn
GROUP BY age_group
ORDER BY churn_rate DESC;

-- Analyze if churn rates differ between male and female customers.
SELECT gender, 
       COUNT(*) AS total_customers, 
       COUNT(CASE WHEN exited = 'Yes' THEN 1 END) AS churned_customers, 
       ROUND(COUNT(CASE WHEN exited = 'Yes' THEN 1 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY gender;


--- END ---










































