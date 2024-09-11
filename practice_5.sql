--EX1:
SELECT
CONTINENT,
FLOOR(AVG(B.POPULATION)) AS AVG_POPULATION
FROM COUNTRY A
JOIN CITY B
ON A.CODE = B.COUNTRYCODE
GROUP BY CONTINENT

--EX2:
SELECT
ROUND(
(
SELECT
  COUNT(B.email_id)
FROM emails A
LEFT JOIN texts B ON A.email_id = B.email_id
WHERE B.signup_action = 'Confirmed'
)
/CAST(COUNT(DISTINCT A.email_id) AS DECIMAL),2) AS confirm_rate
FROM emails A
LEFT JOIN texts B ON A.email_id = B.email_id

--EX3:
SELECT
age_bucket,
ROUND(
SUM(CASE
  WHEN activity_type = 'send' THEN time_spent
  ELSE 0
END)/
(SUM(CASE
  WHEN activity_type = 'send' THEN time_spent
  ELSE 0
END)+SUM(CASE
  WHEN activity_type = 'open' THEN time_spent
  ELSE 0
END))*100.0,2)
AS send_perc,
  
ROUND(
SUM(CASE
  WHEN activity_type = 'open' THEN time_spent
  ELSE 0
END)/
(SUM(CASE
  WHEN activity_type = 'open' THEN time_spent
  ELSE 0
END)+SUM(CASE
  WHEN activity_type = 'send' THEN time_spent
  ELSE 0
END))*100.0,2)
AS open_perc
  
FROM activities A
JOIN age_breakdown B ON A.user_id = b.user_id
GROUP BY age_bucket

--HOẶC 
SELECT
age_bucket,
ROUND(SUM(time_spent) FILTER (WHERE activity_type = 'open')/SUM(time_spent)*100.0,2) AS open_perc,
ROUND(SUM(time_spent) FILTER (WHERE activity_type = 'send')/SUM(time_spent)*100.0,2) AS send_perc
FROM activities A
JOIN age_breakdown B ON A.user_id = B.user_id
WHERE activity_type IN ('open','send')
GROUP BY age_bucket

--EX4:
SELECT
customer_id
FROM products A
JOIN customer_contracts B ON A.product_id = B.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category) = (SELECT COUNT(DISTINCT product_category) FROM products)

--EX5:
SELECT
    B.reports_to AS employee_id ,
    A.name,
    COUNT(B.employee_id) AS reports_count,
    ROUND(AVG(B.age),0) AS average_age
FROM Employees A
JOIN Employees B ON A.employee_id = B.reports_to
GROUP BY B.reports_to, A.name
ORDER BY employee_id

--EX6:


--EX7:
