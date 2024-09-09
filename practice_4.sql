--EX1:
SELECT
SUM(CASE
  WHEN device_type = 'laptop' THEN 1
  ELSE 0
END) AS laptop_reviews,
SUM(CASE
  WHEN device_type IN ('phone','tablet') THEN 1
  ELSE 0
END) AS mobile_views
FROM viewership

--EX2:
SELECT
x,y,z,
CASE
    WHEN X+Y<=Z THEN 'No'
    WHEN X+Z<=Y THEN 'No'
    WHEN Y+Z<=X THEN 'No'
    ELSE 'Yes'
END AS triangle
FROM Triangle 

--EX3:
SELECT
ROUND(SUM(
CASE
  WHEN call_category = 'n/a' OR call_category IS NULL THEN 1
ELSE 0 END)/CAST(COUNT(*) AS DECIMAL)*100,1)
FROM callers 

--EX4:
SELECT
    NAME
FROM CUSTOMER
WHERE REFEREE_ID <> 2 OR REFEREE_ID IS NULL
ORDER BY NAME

--EX5:
SELECT
survived,
SUM(CASE
    WHEN pclass	= 1 THEN 1 ELSE 0
END) AS first_class,
SUM(CASE
    WHEN pclass = 2 THEN 1 ELSE 0
END) AS second_classs,
SUM(CASE
    WHEN pclass = 3 THEN 1 ELSE 0
END) AS third_class
FROM titanic
GROUP BY survived
