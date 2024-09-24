-- EX1:
SELECT
COUNT(*)
FROM
(
SELECT 
company_id,
COUNT(job_id) AS NUMBER_OF_JOBS
FROM job_listings
GROUP BY company_id, title, description
HAVING COUNT(job_id) > 1
) COUNT_JOB

--EX2:
WITH CTE_REVENUE AS
(
SELECT
category, product,
SUM(spend) total_spend
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product
),

--TÌM TOP 1
CTE_MAX1 AS
(
SELECT
category,
MAX(total_spend) max_spend
FROM CTE_REVENUE
GROUP BY category
),
--TÌM TOP 2
CTE_MAX2 AS
(
SELECT
category,
MAX(total_spend) max_spend
FROM CTE_REVENUE
WHERE total_spend NOT IN (SELECT max_spend FROM CTE_MAX1 WHERE CTE_MAX1.category = CTE_REVENUE.category)
GROUP BY category
),
--UNION CTE_MAX1 VÀ CTE_MAX2
CTE_MERGE AS
(
SELECT*FROM CTE_MAX1
UNION
SELECT*FROM CTE_MAX2 
)

SELECT
A.category,
product,
max_spend
FROM CTE_MERGE A
JOIN CTE_REVENUE B ON A.category = B.category
WHERE total_spend = max_spend
    
--EX3:
SELECT
COUNT(*)
FROM
(
SELECT
policy_holder_id,
COUNT(case_id) COUNT_CALL
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3
) COUNT_CALL

--EX4:
SELECT
A.page_id
FROM pages A
LEFT JOIN page_likes B ON A.page_id = B.page_id
WHERE B.page_id IS NULL
ORDER BY A.page_id

--EX5:
SELECT
DISTINCT EXTRACT(MONTH FROM event_date) AS month,
COUNT(DISTINCT user_id) AS monthly_active_users
FROM user_actions
WHERE EXTRACT(MONTH FROM event_date) = 7
AND user_id IN
(
  SELECT user_id FROM user_actions WHERE EXTRACT(MONTH FROM event_date) = 6
)
GROUP BY DISTINCT EXTRACT(MONTH FROM event_date)
    
--EX6:
SELECT
DATE_FORMAT(trans_date, '%Y-%m') AS month,
country,
COUNT(id) trans_count,
SUM(
    CASE
    WHEN state = 'approved' THEN 1
    ELSE 0
END) approved_count,
SUM(amount) trans_total_amount,
SUM(
    CASE
    WHEN state = 'approved' THEN amount
    ELSE 0
END) approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country

--EX7: (RUN CODE CHẠY RA ĐÚNG NHƯNG SUBMIT THÌ BỊ SAI)
WITH CTE_MIN_MONTH AS
(
SELECT
MIN(year) AS year
FROM Sales 
GROUP BY product_id
),
CTE_QUANTITY AS
(
SELECT
product_id,
SUM(quantity) quantity
FROM Sales A
JOIN CTE_MIN_MONTH B ON A.year = B.year
GROUP BY product_id
)
--QUERY CHÍNH
SELECT
A.product_id,
A.year AS first_year,
C.quantity,
A.price
FROM Sales A
JOIN CTE_MIN_MONTH B ON A.year = B.year
JOIN CTE_QUANTITY C ON A.product_id = C.product_id 

--EX8:
SELECT
customer_id 
FROM Customer 
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product)

--EX9:
SELECT
employee_id
FROM Employees 
WHERE salary < 30000
AND manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY employee_id

--EX10:
SELECT
COUNT(*)
FROM
(
SELECT 
company_id,
COUNT(job_id) AS NUMBER_OF_JOBS
FROM job_listings
GROUP BY company_id, title, description
HAVING COUNT(job_id) > 1
) COUNT_JOB

--EX11: (RUN CODE ĐÚNG NHUNG SUBMIT THÌ SAI)
WITH CTE_AVG_RATING AS
(
SELECT
movie_id,
AVG(rating) AS AVG_RATING
FROM MovieRating
WHERE DATE_FORMAT(created_at,'%Y-%m')='2020-02'
GROUP BY movie_id
),
CTE_MAX_RATING AS
(
SELECT
title AS results,
MAX(AVG_RATING)
FROM CTE_AVG_RATING A
JOIN Movies B ON A.movie_id = B.movie_id
GROUP BY A.movie_id,title
HAVING MAX(AVG_RATING) = (SELECT MAX(AVG_RATING) FROM CTE_AVG_RATING)
ORDER BY title
LIMIT 1
),
CTE_COUNT_FILM AS
(
SELECT
user_id,
COUNT(movie_id) AS COUNT_FILM
FROM MovieRating 
GROUP BY user_id
),
CTE_MAX_RATED AS
(
SELECT
name AS results,
MAX(COUNT_FILM)
FROM CTE_COUNT_FILM A
JOIN Users B ON A.user_id = B.user_id
GROUP BY A.user_id, name
HAVING MAX(COUNT_FILM) = (SELECT MAX(COUNT_FILM) FROM CTE_COUNT_FILM)
ORDER BY name
LIMIT 1
)
-- QUERY CHÍNH
SELECT results
FROM CTE_MAX_RATED
UNION
SELECT results
FROM CTE_MAX_RATING

--EX12:
WITH CTE_ACC AS
(
SELECT
requester_id AS id,
COUNT(accepter_id) AS num
FROM RequestAccepted
GROUP BY requester_id
),
CTE_REQ AS
(
SELECT
accepter_id AS id,
COUNT(requester_id) AS num
FROM RequestAccepted
GROUP BY accepter_id
),
CTE_SUM AS
(
SELECT A.*
FROM CTE_REQ A
LEFT JOIN CTE_ACC B ON A.id = B.id
UNION
SELECT B.*
FROM CTE_REQ A
RIGHT JOIN CTE_ACC B ON A.id = B.id
),
CTE_MAX AS
(
SELECT
id,
SUM(num) AS num
FROM CTE_SUM
GROUP BY id
)
SELECT
id,
MAX(num) AS num
FROM CTE_MAX
GROUP BY id
HAVING MAX(num) = (SELECT MAX(num) FROM CTE_MAX)



















