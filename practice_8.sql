--EX1:
--CÁCH 1:
WITH CTE_A AS
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) stt
FROM Delivery
),
CTE_B AS
(
SELECT
CASE
    WHEN order_date = customer_pref_delivery_date THEN stt = 1
    ELSE 0
END AS status
FROM CTE_A
WHERE stt = 1
)
SELECT
ROUND(SUM(status)/COUNT(*)*100,2) AS immediate_percentage
FROM CTE_B
  
--CÁCH 2:
SELECT
ROUND(AVG(order_date=customer_pref_delivery_date)*100,2) AS immediate_percentage
FROM Delivery B
WHERE order_date = 
(
SELECT
MIN(order_date)
FROM Delivery A
WHERE A.customer_id = B.customer_id
GROUP BY customer_id 
)

--EX2:
WITH CTE_A AS
(
SELECT
player_id,
MIN(event_date)
FROM Activity 
GROUP BY player_id
),
CTE_B AS
(
SELECT *,
LEAD(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS latter_date
FROM Activity
)
SELECT
ROUND(COUNT(DISTINCT CTE_B.player_id)/COUNT(CTE_A.player_id),2) AS fraction
FROM CTE_A, CTE_B
WHERE CTE_B.latter_date - CTE_B.event_date = 1
--> CÁCH NÀY KHÔNG TỐI ƯU VÌ CÓ THỂ TÍNH LUÔN NHỮNG USER KO ĐĂNG NHẬP VÀO NGÀY TIẾP THEO NGÀY ĐẦU TIÊN MÀ ĐĂNG NHẬP TIẾP VÀO NHỮNG NGÀY SAU ĐÓ

    --CÁCH CODE TỐI ƯU CHO MỌI TRƯỜNG HỢP
WITH CTE_A AS
(
SELECT
player_id,
DATE_ADD(MIN(event_date), INTERVAL 1 DAY)
FROM Activity 
GROUP BY player_id
)
SELECT
ROUND(COUNT(player_id)/
(SELECT COUNT(DISTINCT player_id) FROM Activity),2) AS fraction
FROM Activity
WHERE (player_id, event_date) IN (SELECT * FROM CTE_A)

--EX3:
SELECT id,
CASE
    WHEN id%2 != 0 THEN COALESCE(LEAD(student) OVER (ORDER BY id), student)
    ELSE LAG(student) OVER (ORDER BY id)
END AS student
FROM Seat

--EX4:
WITH CTE_A AS
(
SELECT visited_on, SUM(amount) as amount
FROM Customer
GROUP BY visited_on
)
SELECT * FROM
(
SELECT
visited_on,
CASE
WHEN visited_on IN (SELECT DATE_ADD(visited_on, INTERVAL 6 DAY) FROM Customer) THEN
SUM(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
END AS amount,
CASE
WHEN visited_on IN (SELECT DATE_ADD(visited_on, INTERVAL 6 DAY) FROM Customer) THEN
ROUND(AVG(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2)
END AS average_amount
FROM CTE_A
) AS A
WHERE amount IS NOT NULL

--EX5:
SELECT
ROUND(SUM(tiv_2016),2) AS tiv_2016
FROM Insurance
WHERE (lat, lon) IN
(SELECT lat, lon FROM Insurance GROUP BY lat, lon HAVING COUNT(pid) = 1)
AND tiv_2015 IN
(SELECT tiv_2015 FROM Insurance GROUP BY tiv_2015 HAVING COUNT(pid) > 1)

--EX6:
WITH CTE_A AS
(
SELECT
name, salary, departmentId,
DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC) AS rank_col
FROM Employee
)

SELECT
B.name AS Department,
CTE_A.name AS Employee,
salary
FROM CTE_A
JOIN Department B ON CTE_A.departmentId = B.id
WHERE rank_col <= 3

--EX7:
SELECT
person_name
FROM
(
SELECT
person_name, weight, turn,
SUM(weight) OVER (ORDER BY turn) AS total_weight
FROM Queue
) AS CTE_A
WHERE total_weight <= 1000
ORDER BY turn DESC
LIMIT 1

--EX8:

