SELECT * FROM Telcom.customer;

SELECT COUNT(Customer_ID) as total_records FROM Telcom.customer;



-- Check for duplicates --
SELECT Customer_ID, COUNT( Customer_ID ) as count
FROM customer
GROUP BY Customer_ID
HAVING count(Customer_ID) > 1;


-- What is the overall churn rate?
SELECT COUNT(Customer_ID) as total_Churned_customers FROM Telcom.customer WHERE Customer_Status = 'Churned';

SELECT (COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 END) * 100.0) / COUNT(Customer_ID) AS churn_rate
FROM customer;

-- What is the Revenue Lost Due to Churned Customers?
SELECT 
    Customer_Status, 
    COUNT(Customer_ID) AS customer_count,
    SUM(Total_Revenue) AS total_revenue,
    ROUND((SUM(Total_Revenue) * 100.0) / (SELECT SUM(Total_Revenue) FROM customer), 1) AS revenue_percentage
FROM 
    customer
GROUP BY 
    Customer_Status;

-- Churn Rate by Customer Tenure
-- To analyze how customer churn varies based on the length of time (tenure) customers have stayed with the company.
SELECT
    CASE 
        WHEN Tenure_in_Months <= 6 THEN '0-6 months'
        WHEN Tenure_in_Months <= 12 THEN '7-12 months'
        WHEN Tenure_in_Months <= 24 THEN '13-24 months'
        ELSE '25+ months'
    END AS Tenure_Group,
    COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE NULL END) AS churned_customers,
    COUNT(Customer_ID) AS total_customers,
    ROUND((COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE NULL END) * 100.0) / COUNT(Customer_ID), 1) AS churn_rate_percentage
FROM 
    customer
GROUP BY
    CASE 
        WHEN Tenure_in_Months <= 6 THEN '0-6 months'
        WHEN Tenure_in_Months <= 12 THEN '7-12 months'
        WHEN Tenure_in_Months <= 24 THEN '13-24 months'
        ELSE '25+ months'
    END
ORDER BY
    churn_rate_percentage DESC;

-- Churn Rate by Contract Type
SELECT 
    Contract,
    COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE NULL END) AS churned_customers,
    COUNT(Customer_ID) AS total_customers,
    ROUND((COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE NULL END) * 100.0) / COUNT(Customer_ID), 1) AS churn_rate_percentage
FROM 
    customer
GROUP BY 
    Contract
ORDER BY 
    churn_rate_percentage DESC;

-- Which cities had the highest churn rates where we there is good customer base?
-- Churn Rate by City
Select city, Count(customer_id) from customer group by city order by count(customer_id) desc;
SELECT 
    City,
    COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE NULL END) AS churned_customers,
    COUNT(Customer_ID) AS total_customers,
    ROUND((COUNT(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE NULL END) * 100.0) / COUNT(Customer_ID), 1) AS churn_rate_percentage
FROM 
    customer
GROUP BY 
    City
HAVING 
	total_customers > 50
ORDER BY 
    churned_customers DESC
LIMIT 10; 

-- What are the general reasons for churn?
SELECT 
    Churn_Category,
    ROUND(SUM(Total_Revenue), 0) AS churned_revenue,
    COUNT(Customer_ID) AS churned_customers,
    ROUND((COUNT(Customer_ID) * 100.0) / (SELECT COUNT(Customer_ID) FROM customer WHERE Customer_Status = 'Churned'), 1) AS percentage
FROM 
    customer
WHERE 
    Customer_Status = 'Churned'
GROUP BY 
    Churn_Category
ORDER BY 
    percentage DESC;

-- Specific reasons for churn
-- why exactly did customers churn?
SELECT 
    Churn_Reason,
    Churn_Category,
    COUNT(Customer_ID) AS churned_customers,
    ROUND(SUM(Total_Revenue), 0) AS churned_revenue,
    ROUND((COUNT(Customer_ID) * 100.0) / (SELECT COUNT(Customer_ID) FROM customer WHERE Customer_Status = 'Churned'), 1) AS percentage
FROM 
    customer
WHERE 
    Customer_Status = 'Churned'
GROUP BY 
    Churn_Reason,Churn_Category
ORDER BY 
    churned_revenue DESC
LIMIT 5;

-- What offeres did churned customers have 
SELECT 
    Offer,
    COUNT(Customer_ID) AS churned_customers,
    ROUND((COUNT(Customer_ID) * 100.0) / (SELECT COUNT(*) FROM customer WHERE Customer_Status = 'Churned'), 1) AS percentage
FROM 
    customer
WHERE 
    Customer_Status = 'Churned'
GROUP BY 
    Offer
ORDER BY 
    churned_customers DESC;

-- What Internet Service Type did churned customers have?

SELECT Internet_Service, 
       COUNT(Customer_ID) AS total_customers,
       SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND((SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) * 100.0) / COUNT(Customer_ID), 2) AS churn_rate
FROM customer
GROUP BY Internet_Service
ORDER BY churn_rate DESC;

SELECT
    Internet_Type,
    COUNT(Customer_ID) AS churned_customers,
    ROUND((COUNT(Customer_ID) * 100.0) / (SELECT COUNT(Customer_ID) FROM customer WHERE Customer_Status = 'Churned'), 1) AS percentage
FROM
    customer
WHERE 
    Customer_Status = 'Churned'
GROUP BY
    Internet_Type
ORDER BY 
    churned_customers DESC;
    
-- Internet Type for Competitor-Driven Churn
SELECT
    Internet_Type,
    Churn_Category,
    COUNT(Customer_ID) AS churned_customers,
    ROUND((COUNT(Customer_ID) * 100.0) / (SELECT COUNT(*) FROM customer WHERE Customer_Status = 'Churned' AND Churn_Category = 'Competitor'), 1) AS percentage
FROM
    customer
WHERE 
    Customer_Status = 'Churned'
    AND Churn_Category = 'Competitor'
GROUP BY
    Internet_Type,
    Churn_Category
ORDER BY 
    percentage DESC;

-- Did churners have premium tech support?
SELECT
    Premium_Tech_Support,
    COUNT(Customer_ID) AS churned_customers,
    ROUND((COUNT(Customer_ID) * 100.0) / (SELECT COUNT(*) FROM customer WHERE Customer_Status = 'Churned'), 1) AS percentage
FROM
    customer
WHERE 
    Customer_Status = 'Churned'
GROUP BY
    Premium_Tech_Support
ORDER BY 
    churned_customers DESC;

-- How Old Were Churned customers?
SELECT  
    CASE
        WHEN Age <= 30 THEN '19 - 30 yrs'
        WHEN Age <= 40 THEN '31 - 40 yrs'
        WHEN Age <= 50 THEN '41 - 50 yrs'
        WHEN Age <= 60 THEN '51 - 60 yrs'
        ELSE  '> 60 yrs'
    END AS Age_Group,
    COUNT(Customer_ID) AS Churned_Customers,
    ROUND(COUNT(Customer_ID) * 100.0 / (SELECT COUNT(Customer_ID) FROM customer WHERE Customer_Status = 'Churned'), 1) AS Percentage
FROM 
    customer
WHERE
    Customer_Status = 'Churned'
GROUP BY
    CASE
        WHEN Age <= 30 THEN '19 - 30 yrs'
        WHEN Age <= 40 THEN '31 - 40 yrs'
        WHEN Age <= 50 THEN '41 - 50 yrs'
        WHEN Age <= 60 THEN '51 - 60 yrs'
        ELSE  '> 60 yrs'
    END
ORDER BY
    Percentage DESC;
-- What Gender Were Churned customers ?
SELECT
    Gender,
    COUNT(Customer_ID) AS Churned_Customers,
    ROUND(COUNT(Customer_ID) * 100.0 / (SELECT COUNT(Customer_ID) FROM customer WHERE Customer_Status = 'Churned'), 1) AS Churn_Percentage
FROM
    customer
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Gender
ORDER BY
    Churn_Percentage DESC;
    
-- Do Churned customers Have Phone Lines?
SELECT
    Phone_Service,
    COUNT(Customer_ID) AS Churned_Customers,
    ROUND(COUNT(Customer_ID) * 100.0 / (SELECT COUNT(Customer_ID) FROM customer WHERE Customer_Status = 'Churned'), 1) AS Percentage
FROM
    customer
WHERE
    Customer_Status = 'Churned'
GROUP BY 
    Phone_Service
ORDER BY
    Percentage DESC;

    
-- Customer Lifetime Value (CLV)
SELECT 
    Customer_ID,
    Customer_Status,
    contract,
    Monthly_Charge,
    Tenure_in_Months,
    (Monthly_Charge * Tenure_in_Months) AS CLV
FROM 
    customer
ORDER BY 
    CLV DESC;

-- Identifying High Valued Customers
SELECT 
    Customer_ID,
    Monthly_Charge,
    Tenure_in_Months,
    (Monthly_Charge * Tenure_in_Months) AS CLV
FROM 
    customer
WHERE 
    (Monthly_Charge * Tenure_in_Months) > (
        SELECT AVG(Monthly_Charge * Tenure_in_Months) FROM customer
    )
ORDER BY 
    CLV DESC;

-- Analyzing CLV Vs Churn 
SELECT 
    Customer_Status,
    ROUND(AVG(Monthly_Charge * Tenure_in_Months), 2) AS Average_CLV
FROM 
    customer
GROUP BY 
    Customer_Status;
