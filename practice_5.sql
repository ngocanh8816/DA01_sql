--BÀI TẬP TRÊN WEB
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
SELECT
    product_name,
    SUM(unit) AS unit
FROM Orders A
JOIN Products B ON A.product_id = B.product_id
WHERE EXTRACT(YEAR FROM order_date) = 2020 AND EXTRACT(MONTH FROM order_date) = 02
GROUP BY product_name
HAVING SUM(unit) >= 100

--EX7:
SELECT
A.page_id
FROM pages A
LEFT JOIN page_likes B ON A.page_id = B.page_id
WHERE B.page_id IS NULL
ORDER BY A.page_id

--MID-COURSE TEST
--CÂU 1:
SELECT
	DISTINCT REPLACEMENT_COST
FROM FILM
ORDER BY REPLACEMENT_COST
LIMIT 1

--CÂU 2:
SELECT
COUNT(FILM_ID)
FROM FILM
WHERE REPLACEMENT_COST BETWEEN 9.99 AND 19.99
GROUP BY 
(CASE
	WHEN REPLACEMENT_COST BETWEEN 9.99 AND 19.99 THEN 'LOW'
	WHEN REPLACEMENT_COST BETWEEN 20.00 AND 24.99 THEN 'MEDIUM'
	WHEN REPLACEMENT_COST BETWEEN 25.00 AND 29.99 THEN 'HIGH'
END)

--CÂU 3:
SELECT
	MAX(A.length),
	C.name
FROM FILM A 
JOIN public.film_category B ON A.film_id = B.film_id
JOIN CATEGORY C ON B.category_id = C.category_id
WHERE C.name IN ('Drama','Sports')
GROUP BY C.name
ORDER BY MAX(A.LENGTH) DESC
LIMIT 1

--CÂU 4:
SELECT
	C.name,
	COUNT(A.film_id)
FROM FILM A 
JOIN public.film_category B ON A.film_id = B.film_id
JOIN CATEGORY C ON B.category_id = C.category_id
GROUP BY C.name
ORDER BY COUNT(A.film_id) DESC
LIMIT 1

--CÂU 5:
SELECT
	first_name || ' ' || last_name AS ACTOR_NAME,
	COUNT(film_id) AS TOTAL_FILM
FROM public.film_actor A
JOIN public.actor B ON A.actor_id = B.actor_id
GROUP BY first_name || ' ' || last_name
ORDER BY TOTAL_FILM DESC
LIMIT 1

--CÂU 6:
SELECT
COUNT(*) AS TOTAL_ADDRESS
FROM public.address A
LEFT JOIN public.customer B ON A.address_id = B.address_id
WHERE customer_id IS NULL

--CÂU 7:
SELECT
	D.city,
	SUM(amount) AS TOTAL_AMOUNT
FROM PAYMENT A
JOIN public.customer B ON A.customer_id = B.customer_id
JOIN public.address C ON B.address_id = C.address_id
JOIN public.city D ON C.city_id = D.city_id
GROUP BY D.city
ORDER BY TOTAL_AMOUNT DESC
LIMIT 1

--CÂU 8:
SELECT
	city || ',' || ' ' || country AS CITY_COUNTRY,
	SUM(amount) AS TOTAL_AMOUNT
FROM PAYMENT A
JOIN public.customer B ON A.customer_id = B.customer_id
JOIN public.address C ON B.address_id = C.address_id
JOIN public.city D ON C.city_id = D.city_id
JOIN public.country E ON D.country_id = E.country_id
GROUP BY city || ',' || ' ' || country
ORDER BY TOTAL_AMOUNT DESC 
LIMIT 1















