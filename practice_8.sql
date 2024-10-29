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


--EX3:


--EX4:


--EX5:


--EX6:


--EX7:


--EX8:

