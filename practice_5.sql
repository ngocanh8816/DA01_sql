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


--EX4:


--EX5:


--EX6:


--EX7:
